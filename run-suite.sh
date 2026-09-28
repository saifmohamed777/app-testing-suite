#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
CONFIG="${CONFIG_FILE:-$ROOT/config.env}"

if [[ ! -f "$CONFIG" ]]; then
  echo "Missing $CONFIG. Run: cp config.example config.env && nano config.env" >&2
  exit 1
fi
# shellcheck disable=SC1090
source "$CONFIG"

: "${TARGET_URL:?Set TARGET_URL in config.env}"
: "${AUTHORIZED:?Set AUTHORIZED=YES in config.env}"
if [[ "$AUTHORIZED" != "YES" ]]; then
  echo "Refusing to scan: set AUTHORIZED=YES only for an asset you own or are explicitly authorized to test." >&2
  exit 1
fi

TARGET_URL="${TARGET_URL%/}"
HOST="${TARGET_HOST:-$(python - "$TARGET_URL" <<'PY'
from urllib.parse import urlparse
import sys
print(urlparse(sys.argv[1]).hostname or '')
PY
)}"
[[ -n "$HOST" ]] || { echo "Could not extract TARGET_HOST" >&2; exit 1; }

OUT="${OUTPUT_DIR:-$ROOT/reports}/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"
exec > >(tee "$OUT/run.log") 2>&1

run() {
  local name="$1"; shift
  echo
  echo "===== $name ====="
  if command -v "$1" >/dev/null 2>&1; then
    "$@" >"$OUT/$name.txt" 2>&1 || echo "[$name] tool returned a non-zero status; inspect its report."
  else
    echo "[$name] skipped: command '$1' is not installed."
  fi
}

cat > "$OUT/metadata.txt" <<EOF
Target: $TARGET_URL
Host: $HOST
Started: $(date -Is)
Mode: authorized, non-destructive checks
EOF

# Passive/basic checks first; no password guessing, exploit execution, or data extraction.
run dns_lookup dig +noall +answer "$HOST"
run tls_check sslyze --regular "$HOST:443"
run headers curl -k -sSIL --max-time 20 "$TARGET_URL"
run api_smoke curl -ksS --max-time 20 -o /dev/null -w 'HTTP %{http_code}\nTime %{time_total}s\n' "$TARGET_URL"
run ports nmap -Pn -T2 --top-ports 100 --version-light "$HOST"
run web_discovery feroxbuster -u "$TARGET_URL" -s 200,204,301,302,307,401,403 -t 5 --rate-limit 10 --silent
run lighthouse lighthouse "$TARGET_URL" --output=json --output-path="$OUT/lighthouse.json" --quiet --chrome-flags="--headless --no-sandbox"
run accessibility axe "$TARGET_URL" --save "$OUT/axe.json"
run api_collection newman run "${POSTMAN_COLLECTION:-collection.json}" --reporters cli,json --reporter-json-export "$OUT/newman.json"

# Source-code checks run when SOURCE_DIR points at a local project.
if [[ -n "${SOURCE_DIR:-}" && -d "$SOURCE_DIR" ]]; then
  run bandit bandit -r "$SOURCE_DIR" -f json -o "$OUT/bandit.json"
  run pip_audit pip-audit
  run pytest pytest -q "$SOURCE_DIR"
fi

printf '\nFinished. Reports: %s\n' "$OUT"
printf 'Review findings manually; an automated scan is not proof that an app is secure.\n'

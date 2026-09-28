#!/data/data/com.termux/files/usr/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
CONFIG="${CONFIG_FILE:-$ROOT/config.env}"
if [[ ! -f "$CONFIG" ]]; then
  echo "❌ config.env missing"
  exit 1
fi
source "$CONFIG"
if [[ "$AUTHORIZED" != "YES" ]]; then
  echo "❌ Set AUTHORIZED=YES in config.env"
  exit 1
fi
TARGET_URL="${TARGET_URL%/}"
HOST="${TARGET_HOST:-$(python3 - "$TARGET_URL" 2>/dev/null <<'PY' || echo 'unknown')}
from urllib.parse import urlparse
import sys
try:
    print(urlparse(sys.argv[1]).hostname or 'unknown')
except:
    print('unknown')
PY
}"
OUT="${OUTPUT_DIR:-$ROOT/reports}/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"
exec 1> >(tee "$OUT/summary.txt")
exec 2>&1
echo "🚀 Starting Tests at $(date)"
echo "Target: $TARGET_URL"
echo "Host: $HOST"
echo "Threads: $THREADS | Timeout: $TIMEOUT"
echo ""
echo "📡 [1/15] DNS Lookup..."
dig +noall +answer "$HOST" @8.8.8.8 > "$OUT/01_dns.txt" 2>&1 || echo "DNS failed" >> "$OUT/01_dns.txt"
echo "📡 [2/15] TLS Certificate..."
sslyze --regular --json-out "$OUT/02_tls.json" "$HOST:443" > /dev/null 2>&1 || openssl s_client -connect "$HOST:443" < /dev/null > "$OUT/02_tls.txt" 2>&1 || echo "TLS check skipped" >> "$OUT/02_tls.txt"
echo "📡 [3/15] HTTP Headers..."
curl -s -k -I --max-time $TIMEOUT "$TARGET_URL" > "$OUT/03_headers.txt" 2>&1 || echo "Headers failed" >> "$OUT/03_headers.txt"
echo "📡 [4/15] Response Body..."
curl -s -k --max-time $TIMEOUT -D "$OUT/04_response_meta.txt" -o "$OUT/04_response.html" "$TARGET_URL" 2>&1 || echo "Response failed" >> "$OUT/04_response.html"
echo "📡 [5/15] Port Scan..."
nmap -Pn -T3 --top-ports 100 --open -oN "$OUT/05_ports.txt" "$HOST" 2>&1 || echo "Nmap failed" >> "$OUT/05_ports.txt"
echo "📡 [6/15] DNS Enumeration..."
nslookup "$HOST" 8.8.8.8 > "$OUT/06_dns_enum.txt" 2>&1 || host "$HOST" > "$OUT/06_dns_enum.txt" 2>&1 || echo "DNS enum failed" >> "$OUT/06_dns_enum.txt"
echo "⚡ [7/15] Connection Speed..."
curl -w "Speed Test: %{time_connect}s connect, %{time_starttransfer}s ttfb, %{time_total}s total\nSize: %{size_download} bytes\n" -o /dev/null -s "$TARGET_URL" > "$OUT/07_speed.txt" 2>&1 || echo "Speed test failed" >> "$OUT/07_speed.txt"
echo "⚡ [8/15] Performance (Lighthouse)..."
if command -v lighthouse &>/dev/null; then
  lighthouse --chrome-flags='--headless --no-sandbox' --output=html --output-path="$OUT/08_lighthouse.html" "$TARGET_URL" >/dev/null 2>&1 || echo "Lighthouse skipped" > "$OUT/08_lighthouse.txt"
else
  echo "Lighthouse not installed" > "$OUT/08_lighthouse.txt"
fi
echo "♿ [9/15] Accessibility (axe)..."
if command -v axe &>/dev/null; then
  axe "$TARGET_URL" --save "$OUT/09_axe.json" >/dev/null 2>&1 || echo "axe check failed" > "$OUT/09_axe.txt"
else
  echo "axe not installed" > "$OUT/09_axe.txt"
fi
echo "🔌 [10/15] API Endpoints..."
if [[ -n "${POSTMAN_COLLECTION:-}" && -f "$POSTMAN_COLLECTION" ]]; then
  if command -v newman &>/dev/null; then
    newman run "$POSTMAN_COLLECTION" --reporters json --reporter-json-export "$OUT/10_api.json" 2>&1 || echo "API tests failed" > "$OUT/10_api.txt"
  else
    echo "newman not installed" > "$OUT/10_api.txt"
  fi
else
  echo "No Postman collection" > "$OUT/10_api.txt"
fi
echo "🔒 [11/15] SSL/TLS Configuration..."
echo | openssl s_client -connect "$HOST:443" -servername "$HOST" 2>/dev/null | openssl x509 -noout -text > "$OUT/11_cert_details.txt" 2>&1 || echo "SSL details failed" >> "$OUT/11_cert_details.txt"
echo "🔍 [12/15] Common Paths..."
for path in /admin /login /api /config /backup /test /debug; do
  curl -s -o /dev/null -w "$path: %{http_code}\n" "$TARGET_URL$path" 2>&1
done > "$OUT/12_common_paths.txt"
echo "📊 [13/15] Source Code Analysis..."
if [[ -n "${SOURCE_DIR:-}" && -d "$SOURCE_DIR" ]]; then
  if command -v bandit &>/dev/null; then
    bandit -r "$SOURCE_DIR" -f json > "$OUT/13_bandit.json" 2>&1 || echo "Bandit failed" > "$OUT/13_bandit.txt"
  fi
  if command -v pip-audit &>/dev/null; then
    pip-audit 2>&1 | head -50 > "$OUT/13_pip_audit.txt" || true
  fi
  if command -v pytest &>/dev/null; then
    pytest "$SOURCE_DIR" -v --tb=short 2>&1 | head -100 > "$OUT/13_pytest.txt" || true
  fi
else
  echo "No SOURCE_DIR configured" > "$OUT/13_analysis.txt"
fi
echo "🌐 [14/15] Whois & DNS Records..."
whois "$HOST" > "$OUT/14_whois.txt" 2>&1 || echo "Whois failed" >> "$OUT/14_whois.txt"
dig "$HOST" ANY > "$OUT/14_dns_records.txt" 2>&1 || echo "DNS records failed" >> "$OUT/14_dns_records.txt"
echo "📝 [15/15] Robots & Sitemap..."
curl -s "$TARGET_URL/robots.txt" > "$OUT/15_robots.txt" 2>&1 || echo "No robots.txt" >> "$OUT/15_robots.txt"
curl -s "$TARGET_URL/sitemap.xml" > "$OUT/15_sitemap.xml" 2>&1 || echo "No sitemap" >> "$OUT/15_sitemap.xml"
echo ""
echo "✅ Tests Complete at $(date)"
echo "📁 Reports: $OUT"
ls -lah "$OUT" 2>/dev/null | tail -20

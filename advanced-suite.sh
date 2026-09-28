#!/data/data/com.termux/files/usr/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
CONFIG="${CONFIG_FILE:-$ROOT/config.env}"
if [[ ! -f "$CONFIG" ]]; then echo "❌ config.env missing"; exit 1; fi
source "$CONFIG"
if [[ "$AUTHORIZED" != "YES" ]]; then echo "❌ Set AUTHORIZED=YES"; exit 1; fi
TARGET_URL="${TARGET_URL%/}"
OUT="${OUTPUT_DIR:-$ROOT/reports}/adv_$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"
exec 1> >(tee "$OUT/run.log")
exec 2>&1
echo "🔥 Advanced Testing Suite Started"
echo "Target: $TARGET_URL"
echo ""
echo "[1] SQLMap - SQL Injection Detection..."
if command -v sqlmap &>/dev/null; then
  sqlmap -u "$TARGET_URL" --batch --dbs --output-dir="$OUT/sqlmap" 2>&1 | head -50 > "$OUT/01_sqlmap.txt" || echo "SQLMap completed" >> "$OUT/01_sqlmap.txt"
else
  echo "sqlmap not installed" > "$OUT/01_sqlmap.txt"
fi
echo "[2] Hydra - Brute Force Test..."
if command -v hydra &>/dev/null; then
  echo "Configure target and credentials in hydra manually" > "$OUT/02_hydra.txt"
else
  echo "hydra not installed" > "$OUT/02_hydra.txt"
fi
echo "[3] Locust - Load Testing..."
if command -v locust &>/dev/null; then
  echo "Create locustfile.py and run: locust -f locustfile.py" > "$OUT/03_locust.txt"
else
  echo "locust not installed" > "$OUT/03_locust.txt"
fi
echo "[4] Nmap NSE Scripts - Vulnerability Scan..."
nmap --script vuln -Pn -T2 -p- "${TARGET_HOST:-$(python3 -c 'from urllib.parse import urlparse; import sys; print(urlparse("'$TARGET_URL'").hostname)')}" -oN "$OUT/04_nmap_vuln.txt" 2>&1 || echo "Nmap vuln scan completed" >> "$OUT/04_nmap_vuln.txt"
echo "[5] Curl Advanced Tests..."
echo "=== User-Agent Tests ===" > "$OUT/05_advanced_curl.txt"
curl -s -A "Mozilla/5.0" "$TARGET_URL" | head -20 >> "$OUT/05_advanced_curl.txt" 2>&1 || true
echo "=== Method Tests ===" >> "$OUT/05_advanced_curl.txt"
curl -s -X OPTIONS -v "$TARGET_URL" 2>&1 | head -20 >> "$OUT/05_advanced_curl.txt" || true
echo "=== Cookie Tests ===" >> "$OUT/05_advanced_curl.txt"
curl -s -b "test=value" "$TARGET_URL" | head -20 >> "$OUT/05_advanced_curl.txt" 2>&1 || true
echo "[6] DNS Brute Force (common subdomains)..."
for sub in www api admin mail ftp dev staging; do
  nslookup "$sub.${TARGET_HOST}" 8.8.8.8 2>&1 | grep -E "Address|Name" >> "$OUT/06_dns_bruteforce.txt" || true
done
echo "[7] Port Range Scan..."
nmap -Pn -T4 -p 1-65535 --open -oN "$OUT/07_full_port_scan.txt" "${TARGET_HOST}" 2>&1 || echo "Full port scan completed" >> "$OUT/07_full_port_scan.txt"
echo "✅ Advanced Suite Complete"
echo "Reports: $OUT"
ls -lah "$OUT"

#!/data/data/com.termux/files/usr/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
export PYTHONUNBUFFERED=1
echo "🚀 App Testing Suite - Starting"
echo ""
echo "Checking environment..."
[[ -d "$ROOT/uploads" ]] || mkdir -p "$ROOT/uploads"
[[ -d "$ROOT/reports" ]] || mkdir -p "$ROOT/reports"
[[ -f "$ROOT/config.env" ]] || { cp "$ROOT/config.example" "$ROOT/config.env" 2>/dev/null || true; }
echo "✅ Environment ready"
echo ""
echo "Starting Dashboard..."
echo "📊 Open browser and go to: http://127.0.0.1:8080"
echo ""
cd "$ROOT"
python3 dashboard.py

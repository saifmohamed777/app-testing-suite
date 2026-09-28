#!/data/data/com.termux/files/usr/bin/bash
set -e
pkg update -y
pkg install -y bash coreutils curl dnsutils git jq nmap openssl python nodejs tmux wget
python -m pip install --upgrade pip setuptools wheel 2>&1 | grep -v "already satisfied" || true
pip install flask flask-cors requests pytest pytest-cov bandit pip-audit sslyze adb 2>&1 | grep -v "already satisfied" || true
npm install -g newman lighthouse @axe-core/cli 2>&1 | grep -E "added|up to date" || true
pip install locust sqlmap appium-client 2>&1 | grep -v "already satisfied" || true
pkg install -y hydra zip unzip 2>&1 || true
echo "✅ Installation complete. Run: bash start.sh"

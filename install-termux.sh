#!/data/data/com.termux/files/usr/bin/bash
pkg update -y
pkg install -y bash coreutils curl dnsutils git jq nmap openssl python nodejs tmux
python -m pip install --upgrade pip 2>/dev/null
python -m pip install requests pytest pytest-cov bandit pip-audit sslyze 2>/dev/null
npm install -g newman lighthouse @axe-core/cli 2>/dev/null
pkg install -y hydra 2>/dev/null
pip install locust sqlmap 2>/dev/null
npm install -g cypress appium 2>/dev/null
echo '✅ Done. Now: cp config.example config.env && nano config.env && bash run-suite.sh'

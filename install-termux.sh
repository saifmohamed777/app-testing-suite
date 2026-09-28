#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Install the non-GUI command-line tools used by run-suite.sh.
# Run only on an owned/authorized device or staging environment.

pkg update -y
pkg install -y bash coreutils curl dnsutils git jq nmap openssl python nodejs tmux

python -m pip install --upgrade pip
python -m pip install --upgrade requests pytest pytest-cov bandit pip-audit sslyze
npm install -g newman lighthouse @axe-core/cli || true

# Optional tools: availability depends on the Termux repository/device.
# Do not fail the complete install when one optional package is unavailable.
pkg install -y rust || true
cargo install feroxbuster || true

echo
printf 'Installation finished. Copy config.example to config.env and edit it before running.\n'

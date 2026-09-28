#!/data/data/com.termux/files/usr/bin/bash
echo "🚀 Quick Start - App Testing Suite"
echo ""
echo "Step 1: Install dependencies"
read -p "Run install-termux.sh? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  bash install-termux.sh
fi
echo ""
echo "Step 2: Create config"
if [[ ! -f config.env ]]; then
  cp config.example config.env
  echo "✅ config.example copied to config.env"
  echo "   Edit it with: nano config.env"
else
  echo "✅ config.env exists"
fi
echo ""
echo "Step 3: Edit config.env"
echo "   - Set AUTHORIZED=YES"
echo "   - Set TARGET_URL=https://your-site.com"
echo ""
echo "Step 4: Run tests"
read -p "Run tests now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  bash run-suite.sh
fi
echo ""
echo "✅ Done! Check reports/ folder for results."

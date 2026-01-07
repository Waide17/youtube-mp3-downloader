#!/bin/bash

echo "============================================"
echo "  YouTube MP3 Downloader - Installation"
echo "============================================"
echo ""

# Vai alla directory dello script
cd "$(dirname "$0")/.."

# Controlla Python
echo "[1/3] Checking Python..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found!"
    echo ""
    echo "Install Python 3:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  brew install python3"
    else
        echo "  sudo apt install python3 python3-pip"
    fi
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "✅ Python $PYTHON_VERSION found"
echo ""

# Crea virtual environment
echo "[2/3] Creating virtual environment..."
python3 -m venv venv

# Attiva virtual environment
source venv/bin/activate

# Aggiorna pip
echo "Upgrading pip..."
pip install --upgrade pip --quiet

# Installa dipendenze
echo "[3/3] Installing dependencies..."
pip install -r requirements.txt --quiet

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed"
else
    echo "❌ Installation failed!"
    exit 1
fi

echo ""
echo "============================================"
echo "  ✅ INSTALLATION COMPLETED!"
echo "============================================"
echo ""
echo "To start the application:"
echo "  ./scripts/start.sh"
echo ""
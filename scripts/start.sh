#!/bin/bash

echo "============================================"
echo "  YouTube MP3 Downloader - Starting"
echo "============================================"
echo ""

# Vai alla directory del progetto
cd "$(dirname "$0")/.."

# Attiva virtual environment se esiste
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Avvia il server
echo "Starting server on http://localhost:5000"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Apri browser dopo 2 secondi (in background)
(sleep 2 && python3 -m webbrowser http://localhost:5000) &

# Avvia Flask
python3 src/app.py
@echo off
chcp 65001 >nul
title YouTube MP3 Downloader - Installazione
color 0B

echo.
echo ╔════════════════════════════════════════════╗
echo ║   YouTube MP3 Queue Downloader             ║
echo ║   Installazione Automatica                 ║
echo ╚════════════════════════════════════════════╝
echo.
echo Questo script installerà automaticamente:
echo  • Python (se necessario)
echo  • Flask (server web)
echo  • yt-dlp (downloader YouTube)
echo  • FFmpeg (convertitore MP3)
echo.
echo ⏱️  Tempo stimato: 5-10 minuti
echo 📡 Richiede connessione internet
echo.
echo Premi un tasto per iniziare...
pause >nul

REM Vai alla cartella dello script
cd /d "%~dp0"

REM ==========================================
REM STEP 1: Verifica/Installa Python
REM ==========================================
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo [1/4] Controllo Python...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python non trovato
    echo.
    echo 📥 Inizio download Python 3.11.8...
    echo    (Dimensione: ~25MB)
    echo.
    
    REM Scarica Python installer
    powershell -Command "& {$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.8/python-3.11.8-amd64.exe' -OutFile 'python_installer.exe'}" 2>nul
    
    if exist "python_installer.exe" (
        echo ✅ Download completato
        echo.
        echo 🔧 Installazione Python in corso...
        echo    IMPORTANTE: Se appare una finestra, clicca "Sì"
        echo.
        
        REM Installa Python silenziosamente
        start /wait python_installer.exe /quiet InstallAllUsers=0 PrependPath=1 Include_pip=1 Include_test=0
        
        REM Pulisci
        del python_installer.exe
        
        REM Aggiorna PATH per questa sessione
        set PATH=%LOCALAPPDATA%\Programs\Python\Python311;%LOCALAPPDATA%\Programs\Python\Python311\Scripts;%PATH%
        
        REM Verifica installazione
        timeout /t 2 /nobreak >nul
        python --version >nul 2>&1
        if errorlevel 1 (
            color 0C
            echo.
            echo ❌ ERRORE: Installazione Python fallita!
            echo.
            echo 💡 Soluzione:
            echo    1. Chiudi questa finestra
            echo    2. Scarica Python da: https://www.python.org/downloads/
            echo    3. Durante l'installazione, seleziona "Add Python to PATH"
            echo    4. Rilancia INSTALLER.bat
            echo.
            pause
            exit /b 1
        )
        
        echo ✅ Python installato con successo!
    ) else (
        color 0E
        echo ⚠️  Download Python fallito!
        echo.
        echo 💡 Installazione manuale:
        echo    1. Vai su: https://www.python.org/downloads/
        echo    2. Scarica "Windows installer (64-bit)"
        echo    3. Esegui l'installer
        echo    4. ✅ Seleziona "Add Python to PATH"
        echo    5. Clicca "Install Now"
        echo    6. Rilancia questo script
        echo.
        pause
        exit /b 1
    )
) else (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VER=%%i
    echo ✅ Python %PYTHON_VER% già installato
)
echo.

REM ==========================================
REM STEP 2: Installa dipendenze Python
REM ==========================================
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo [2/4] Installazione librerie Python...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 📦 Installazione in corso:
echo    • flask (server web)
echo    • flask-cors (compatibilità browser)
echo    • yt-dlp (downloader YouTube)
echo.

python -m pip install --upgrade pip --quiet --disable-pip-version-check
pip install flask flask-cors yt-dlp --quiet --disable-pip-version-check

if errorlevel 1 (
    color 0C
    echo ❌ Installazione fallita!
    echo.
    echo 💡 Riprova eseguendo manualmente:
    echo    pip install flask flask-cors yt-dlp
    echo.
    pause
    exit /b 1
)

echo ✅ Librerie installate con successo
echo.

REM ==========================================
REM STEP 3: Installa FFmpeg
REM ==========================================
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo [3/4] Installazione FFmpeg...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎵 FFmpeg è necessario per convertire in MP3
echo.

ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo 📥 Download FFmpeg in corso...
    pip install yt-dlp[default] --quiet --disable-pip-version-check
    
    if errorlevel 1 (
        color 0E
        echo ⚠️  Installazione FFmpeg fallita
        echo.
        echo Il programma funzionerà, ma potrebbero esserci
        echo problemi con la conversione in MP3.
        echo.
        echo 💡 Per risolvere dopo:
        echo    pip install yt-dlp[default]
        echo.
    ) else (
        echo ✅ FFmpeg installato
    )
) else (
    echo ✅ FFmpeg già presente
)
echo.

REM ==========================================
REM STEP 4: Verifica file necessari
REM ==========================================
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo [4/4] Verifica file...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set FILES_OK=1

if not exist "app.py" (
    echo ❌ app.py mancante
    set FILES_OK=0
)

if not exist "index.html" (
    echo ❌ index.html mancante
    set FILES_OK=0
)

if not exist "start.bat" (
    echo ⚠️  start.bat mancante (consigliato)
)

if %FILES_OK%==0 (
    color 0C
    echo.
    echo ❌ ERRORE: File mancanti!
    echo.
    echo Assicurati che la cartella contenga:
    echo  • INSTALLER.bat
    echo  • app.py
    echo  • index.html
    echo  • start.bat
    echo.
    pause
    exit /b 1
)

echo ✅ Tutti i file presenti
echo.

REM ==========================================
REM TEST VELOCE
REM ==========================================
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo Test veloce...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

python -c "import flask; import flask_cors; import yt_dlp" 2>nul
if errorlevel 1 (
    color 0E
    echo ⚠️  Alcune librerie potrebbero non funzionare
    echo.
) else (
    echo ✅ Test superato!
)
echo.

REM ==========================================
REM COMPLETAMENTO
REM ==========================================
timeout /t 1 /nobreak >nul
cls
color 0A

echo.
echo.
echo ╔════════════════════════════════════════════╗
echo ║                                            ║
echo ║     ✅ INSTALLAZIONE COMPLETATA! ✅         ║
echo ║                                            ║
echo ╚════════════════════════════════════════════╝
echo.
echo.
echo 🎉 Tutto pronto per l'uso!
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo  COME USARE:
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo  1️⃣  Chiudi questa finestra
echo.
echo  2️⃣  Fai doppio click su: start.bat
echo.
echo  3️⃣  Inizia a scaricare! 🎵
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 💡 Suggerimento:
echo    Puoi creare un collegamento a start.bat
echo    sul desktop per accesso rapido!
echo.
echo 📖 Per istruzioni dettagliate, apri: LEGGIMI.txt
echo.
echo.
echo Premi un tasto per chiudere...
pause >nul
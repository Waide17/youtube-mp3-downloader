@echo off
echo ============================================
echo   YouTube MP3 Queue Downloader
echo ============================================
echo.

REM Vai alla cartella dello script
cd /d "%~dp0"

REM Controlla se Python è installato
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERRORE] Python non trovato!
    echo Installa Python da: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

echo [OK] Python trovato
echo.

REM Controlla se le dipendenze sono installate
echo Verifica dipendenze...
pip show flask >nul 2>&1
if errorlevel 1 (
    echo [INFO] Installazione dipendenze in corso...
    pip install flask flask-cors yt-dlp
    echo.
)

echo [OK] Dipendenze pronte
echo.

REM Avvia il server in una nuova finestra
echo Avvio server...
start "YouTube MP3 Downloader Server" cmd /k "python server.py"

REM Attendi che il server si avvii
echo Attendi avvio server...
timeout /t 3 /nobreak >nul

REM Apri il browser
echo Apertura browser...
start http://localhost:5000

echo.
echo ============================================
echo   Server avviato!
echo   URL: http://localhost:5000
echo ============================================
echo.
echo Per fermare il server, chiudi la finestra del terminale
echo.
pause
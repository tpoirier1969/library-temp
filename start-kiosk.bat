@echo off
setlocal

:: Set log file location
set LOGFILE=C:\AandD2025remake\kiosk-log.txt

echo === Kiosk start: %DATE% %TIME% === >> "%LOGFILE%"

cd /d C:\AandD2025remake\HistoryMuseum

echo Starting Python HTTP server... >> "%LOGFILE%"
start "" /min cmd /c "python -m http.server"

:: Wait for server to respond
:waitloop
curl http://localhost:8000/AandD_Home.html >nul 2>&1
if errorlevel 1 (
    echo [%TIME%] Waiting for server to respond... >> "%LOGFILE%"
    timeout /t 1 >nul
    goto waitloop
)

echo [%TIME%] Server is up. Launching Edge... >> "%LOGFILE%"

:launchloop
taskkill /f /im msedge.exe >nul 2>&1
echo [%TIME%] Starting Edge in kiosk mode... >> "%LOGFILE%"

start "" /wait msedge --kiosk "http://localhost:8000/AandD_Home.html" ^
  --no-first-run ^
  --no-default-browser-check ^
  --disk-cache-size=1 ^
  --disable-application-cache ^
  --disable-cache ^
  --disable-features=EdgeTips ^
  --disable-infobars ^
  --disable-session-crashed-bubble ^
  --autoplay-policy=no-user-gesture-required ^
  --start-fullscreen

echo [%TIME%] Edge exited. Restarting... >> "%LOGFILE%"
goto launchloop

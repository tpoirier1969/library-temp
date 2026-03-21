@echo off
cd /d C:\AandD2025remake

echo === Starting Python server... ===
start "" /min cmd /c "python -m http.server"

:: Add a quick delay to give the server a chance to boot
timeout /t 2 >nul

echo === Testing server response... ===

:waitloop
curl -s -o nul -w "HTTP Code: %%{http_code}\n" http://localhost:8000/AandD_Home.html
if errorlevel 1 (
    echo Server not ready yet, retrying...
    timeout /t 1 >nul
    goto waitloop
)

echo === Launching Edge ===
start "" msedge "http://localhost:8000/AandD_Home.html"
pause

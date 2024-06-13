@echo off
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell Start-Process '%0' -Verb runAs
    exit /b
)


for /f "tokens=2 delims=," %%i in ('tasklist /fi "IMAGENAME eq audiodg.exe" /fo csv ^| findstr /i "audiodg.exe"') do set PID=%%i


if "%PID%"=="" (
    echo The process audiodg.exe was not found.
    pause
    exit /b 1
)


powershell -Command "Get-Process -Id %PID% | ForEach-Object { $_.ProcessorAffinity=4 }"

echo The affinity of audiodg.exe has been changed to CPU 2
pause

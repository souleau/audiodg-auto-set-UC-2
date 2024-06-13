@echo off
:: Check for administrator rights
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell Start-Process '%0' -Verb runAs
    exit /b
)

REM Find the audiodg.exe process ID
for /f "tokens=2 delims=," %%i in ('tasklist /fi "IMAGENAME eq audiodg.exe" /fo csv ^| findstr /i "audiodg.exe"') do set PID=%%i

REM Check if the process was found
if "%PID%"=="" (
    echo The process audiodg.exe was not found.
    pause
    exit /b 1
)

REM Change the affinity of the audiodg.exe process to CPU 2 (CPU 3 in PowerShell zero-indexed notation)
powershell -Command "Get-Process -Id %PID% | ForEach-Object { $_.ProcessorAffinity=4 }"

echo The affinity of audiodg.exe has been changed to CPU 2
pause

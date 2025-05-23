@echo off
REM BitLocker PIN Check and Setup
REM This script checks if BitLocker PIN is set and launches the setup if needed

powershell.exe -ExecutionPolicy Bypass -File "%~dp0CheckAndLaunchBitLockerPinSetup.ps1"
exit /b %errorlevel%

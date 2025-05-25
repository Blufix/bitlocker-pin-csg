@echo off
REM BitLocker PIN Setup Uninstaller
powershell.exe -ExecutionPolicy Bypass -File "%~dp0UninstallBitLockerPin.ps1"
exit /b %errorlevel%

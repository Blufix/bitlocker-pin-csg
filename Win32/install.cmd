@echo off
REM BitLocker PIN Setup Installer
REM This script runs the SetBitLockerPin.ps1 script to configure BitLocker PIN

powershell.exe -ExecutionPolicy Bypass -File "%~dp0SetBitLockerPin.ps1"
exit /b %errorlevel%

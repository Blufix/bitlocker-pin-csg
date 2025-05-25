# Uninstall BitLocker PIN helper files
# Removes the persistent folder created during installation
$persistPath = "C:\ProgramData\BitLockerPIN"
if (Test-Path -Path $persistPath) {
    Remove-Item -Path $persistPath -Recurse -Force -ErrorAction SilentlyContinue
}

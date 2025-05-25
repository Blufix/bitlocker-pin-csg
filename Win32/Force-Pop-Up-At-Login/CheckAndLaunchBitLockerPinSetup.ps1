# CheckAndLaunchBitLockerPinSetup.ps1
# Script to check if BitLocker PIN is set and launch the setup if not
# Designed to be run at user login

# Check if BitLocker PIN is already set
$bitlockerVolume = Get-BitLockerVolume -MountPoint $env:SystemDrive
$pinProtectorExists = $bitlockerVolume.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'TpmPin' }

# If no PIN protector exists, launch the BitLocker PIN setup
if (-not $pinProtectorExists) {
    Write-Host "BitLocker PIN not set. Launching PIN setup..."
    
    # Use the persistent script location if available
    $persist = 'C:\ProgramData\BitLockerPIN'
    if (Test-Path -Path $persist) {
        $scriptPath = $persist
    } else {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    
    # Run the BitLocker PIN setup script
    & "$scriptPath\ServiceUI.exe" -process:Explorer.exe "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "$scriptPath\FinalBitLockerPopup.ps1"
    
    # Check the result
    if ($LASTEXITCODE -eq 0) {
        # PIN file path
        $pathPINFile = $(Join-Path -Path "$env:SystemRoot\tracing" -ChildPath "168ba6df825678e4da1a.tmp")
        
        # If PIN file exists, apply it
        if (Test-Path -Path $pathPINFile) {
            $encodedText = Get-Content -Path $pathPINFile
            if ($encodedText.Length -gt 0) {
                # Using DPAPI with the same shared key to decrypt the PIN
                $key = (43,155,164,59,21,127,28,43,81,18,198,145,127,51,72,55,39,23,228,166,146,237,41,131,176,14,4,67,230,81,212,214)
                $secure = ConvertTo-SecureString $encodedText -Key $key
                
                # Code for PS5
                $PIN = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
                
                Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -Pin $(ConvertTo-SecureString $PIN -AsPlainText -Force) -TpmAndPinProtector
                
                Write-Host "BitLocker PIN successfully set."
            }
            
            # Cleanup
            Remove-Item -Path $pathPINFile -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "User closed PIN setup dialog without setting a PIN."
        }
    } else {
        Write-Host "BitLocker PIN setup failed with exit code $LASTEXITCODE"
    }
} else {
    Write-Host "BitLocker PIN is already set. No action needed."
}

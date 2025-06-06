# Intune BitLocker PIN Setup

This project is based on the work of Oliver Kieselbach (https://oliverkieselbach.com/2019/08/02/how-to-enable-pre-boot-bitlocker-startup-pin-on-windows-with-intune/)

A secure, modern solution for deploying and enforcing BitLocker PIN protection through Microsoft Intune.

![BitLocker PIN Setup](Win32/SetBitLockerPin.png)

## Overview

This project provides a complete solution for implementing BitLocker drive encryption with PIN authentication in enterprise environments using Microsoft Intune. It features a modern, user-friendly interface that guides users through the PIN setup process while enforcing organizational security requirements.

## Features

- **Modern UI**: Clean, responsive interface for BitLocker PIN setup
- **Secure PIN Handling**: PIN is securely encrypted during the setup process
- **PIN Validation**: Prevents weak PINs through comprehensive validation rules
- **Intune Integration**: Designed for seamless deployment through Microsoft Intune
- **Detection Logic**: Includes script to verify successful implementation

## Components

- **install.cmd**: Main entry point that runs the BitLocker PIN setup process
- **SetBitLockerPin.ps1**: Core script that handles the BitLocker configuration
- **FinalBitLockerPopup.ps1**: Modern UI implementation for PIN entry and validation
- **DetectBitLockerPin.ps1**: Detection script for Intune compliance reporting
- **ServiceUI.exe**: Utility to display the UI in system context
- **Assets**: Contains branding and UI elements
- **UninstallBitLockerPin.ps1**: Removes the persistent helper files
- **uninstall.cmd**: Calls the uninstall script for Intune
- **C:\ProgramData\BitLockerPIN**: Persistent location where the setup script
  copies `ServiceUI.exe`, `FinalBitLockerPopup.ps1` and the `Assets` folder for
  use by the login enforcement script

## Deployment

This package is designed to be deployed as a Win32 application through Microsoft Intune.

### Create the Win32 package

Run the Win32 Content Prep Tool from the repository root:

```
IntuneWinAppUtil.exe -c Win32 -s install.cmd -o .
```

Upload the generated **BitLocker.intunewin** file to Intune.

### Intune application configuration

When adding the app in the Intune portal use the following settings:

* **Install command:** `install.cmd`
* **Uninstall command:** `uninstall.cmd`
* **Detection rules:** Use the `DetectBitLockerPin.ps1` script

After configuring the commands, assign the application to the required user or device groups.

The uninstall command deletes `C:\ProgramData\BitLockerPIN` and the helper scripts placed there during installation.

## Requirements

- Windows 10 or Windows 11
- TPM-enabled device
- Microsoft Intune

## Security Features

- PIN validation prevents sequential numbers and repeating digits
- PIN entry is masked for security
- PIN is encrypted during transit between UI and BitLocker configuration
- Temporary files are securely deleted after PIN setup

## Branding

<div align="center">
    <img src="Win32/Assets/CSG3.png" alt="CSG Logo" width="200"/>
    <p><strong>CSG - Securing your enterprise</strong></p>
</div>

This solution was developed by the CSG team to meet enterprise security requirements while providing a seamless user experience. The modern, branded interface maintains organizational identity while implementing critical security controls.

## Customization

The solution can be customized with your organization's branding:

- Replace the logo images in the Assets folder
- Update color schemes in FinalBitLockerPopup.ps1
- Modify text and messaging to match your organization's terminology

## Handling Closed Dialogs

A companion script is available to handle cases where users close the BitLocker PIN dialog without setting a PIN.

During installation the `SetBitLockerPin.ps1` script copies the required UI files to `C:\ProgramData\BitLockerPIN`. The login script will look for this folder when launching the PIN setup and falls back to its own directory if the folder is missing.

### Intune Platform Script Implementation

The `CheckAndLaunchBitLockerPinSetup.ps1` script can be deployed as an Intune Platform Script:

1. In Intune admin portal, navigate to **Devices** > **Scripts** > **Add** > **Windows** > **PowerShell Script**
2. Upload the `CheckAndLaunchBitLockerPinSetup.ps1` script
3. Configure the following settings:
   - Run script in 64-bit PowerShell: **Yes**
   - Run script as signed-in user: **No** (run as system)
   - Enforce script signature check: Optional
   - Run script even when device is in use: **Yes**
   - Run this script using the logged-on credentials: **No**
4. Assign the script to the same group as your BitLocker PIN setup package


This ensures that any device where a user has closed the BitLocker dialog will be prompted again until they complete the PIN setup process.

## License

© 2025 CSG. All rights reserved.

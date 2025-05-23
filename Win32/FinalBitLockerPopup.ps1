# Modern BitLocker PIN Entry Form
# Final version with reliable display and improved layout

# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Enable visual styles for modern look
[System.Windows.Forms.Application]::EnableVisualStyles()

# PIN validation functions
function Test-IncrementNumber {
    param ([String]$NumberString)
    
    $array = $NumberString.ToCharArray()
    
    for ($i=0; $i -lt $array.count-1; $i++) {
        if ($([int]$array[$i])+1 -eq $array[$i+1]) {
            continue
        } else {
            break
        }
    }
    
    if ($i -eq $array.count-1) {
        return $true
    }
    return $false
}

function Test-DecrementNumber {
    param ([String]$NumberString)
    
    $array = $NumberString.ToCharArray()
    
    for ($i=0; $i -lt $array.count-1; $i++) {
        if ($([int]$array[$i])-1 -eq $array[$i+1]) {
            continue
        } else {
            break
        }
    }
    
    if ($i -eq $array.count-1) {
        return $true
    }
    return $false
}

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "CSG BitLocker PIN Setup"
$form.Size = New-Object System.Drawing.Size(500, 475)  # Increased height to accommodate text
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#102a43")
$form.ForeColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# Use a TableLayoutPanel for better layout control
$mainLayout = New-Object System.Windows.Forms.TableLayoutPanel
$mainLayout.Dock = "Fill"
$mainLayout.Padding = New-Object System.Windows.Forms.Padding(25, 20, 25, 20)
$mainLayout.RowCount = 9
$mainLayout.ColumnCount = 1
$mainLayout.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
$mainLayout.CellBorderStyle = "None"

# Set row heights
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 60))) # Logo
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 40))) # Title
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 30))) # Description
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 25))) # PIN Label
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 35))) # PIN TextBox
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 25))) # Confirm PIN Label
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 35))) # Confirm PIN TextBox
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 25))) # Status
$mainLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 60))) # Security message - increased height

$form.Controls.Add($mainLayout)

# Logo container
$logoContainer = New-Object System.Windows.Forms.Panel
$logoContainer.Dock = "Fill"
$logoContainer.Margin = New-Object System.Windows.Forms.Padding(0, 0, 0, 0)
$mainLayout.Controls.Add($logoContainer, 0, 0)

# Try to load the new smaller logo image using relative path
$logoPath = Join-Path -Path $PSScriptRoot -ChildPath "Assets\CSG3.png"
if (Test-Path $logoPath) {
    try {
        $logoPicture = New-Object System.Windows.Forms.PictureBox
        $logoPicture.Width = 80
        $logoPicture.Height = 40
        $logoPicture.SizeMode = "Zoom"
        $logoPicture.BackColor = [System.Drawing.Color]::Transparent
        $logoPicture.Image = [System.Drawing.Image]::FromFile($logoPath)
        $logoPicture.Location = New-Object System.Drawing.Point(20, 10)  # Position from left border
        $logoContainer.Controls.Add($logoPicture)
    } catch {
        # Fallback to text logo if image loading fails
        Write-Host "Could not load logo image: $_"
        $logoText = New-Object System.Windows.Forms.Label
        $logoText.Text = "CSG"
        $logoText.Font = New-Object System.Drawing.Font("Segoe UI", 26)
        $logoText.ForeColor = [System.Drawing.Color]::White
        $logoText.AutoSize = $true
        $logoText.Location = New-Object System.Drawing.Point(20, 10)
        $logoContainer.Controls.Add($logoText)
    }
}

# Title
$titleContainer = New-Object System.Windows.Forms.Panel
$titleContainer.Dock = "Fill"
$titleContainer.Margin = New-Object System.Windows.Forms.Padding(0)

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "BitLocker Drive Encryption"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(20, 5)  # Position from left border
$titleContainer.Controls.Add($titleLabel)
$mainLayout.Controls.Add($titleContainer, 0, 1)

# Description
$descriptionContainer = New-Object System.Windows.Forms.Panel
$descriptionContainer.Dock = "Fill"
$descriptionContainer.Margin = New-Object System.Windows.Forms.Padding(0)

$descriptionLabel = New-Object System.Windows.Forms.Label
$descriptionLabel.Text = "Please set up a BitLocker PIN to protect your device"
$descriptionLabel.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#bcccdc")
$descriptionLabel.AutoSize = $true
$descriptionLabel.Location = New-Object System.Drawing.Point(20, 5)  # Position from left border
$descriptionContainer.Controls.Add($descriptionLabel)
$mainLayout.Controls.Add($descriptionContainer, 0, 2)

# PIN Label
$pinLabelContainer = New-Object System.Windows.Forms.Panel
$pinLabelContainer.Dock = "Fill"
$pinLabelContainer.Margin = New-Object System.Windows.Forms.Padding(0)

$pinLabel = New-Object System.Windows.Forms.Label
$pinLabel.Text = "Enter PIN:"
$pinLabel.ForeColor = [System.Drawing.Color]::White
$pinLabel.AutoSize = $true
$pinLabel.Location = New-Object System.Drawing.Point(20, 5)  # Position from left border
$pinLabelContainer.Controls.Add($pinLabel)
$mainLayout.Controls.Add($pinLabelContainer, 0, 3)

# PIN TextBox
$pinTextBoxContainer = New-Object System.Windows.Forms.Panel
$pinTextBoxContainer.Dock = "Fill"
$pinTextBoxContainer.Margin = New-Object System.Windows.Forms.Padding(0)

$pinTextBox = New-Object System.Windows.Forms.TextBox
$pinTextBox.PasswordChar = '*'
$pinTextBox.Width = 430
$pinTextBox.Height = 25
$pinTextBox.Location = New-Object System.Drawing.Point(20, 5)  # Position from left border
$pinTextBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#486581")
$pinTextBox.ForeColor = [System.Drawing.Color]::White
$pinTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$pinTextBoxContainer.Controls.Add($pinTextBox)
$mainLayout.Controls.Add($pinTextBoxContainer, 0, 4)

# Confirm PIN Label
$confirmPinLabelContainer = New-Object System.Windows.Forms.Panel
$confirmPinLabelContainer.Dock = "Fill"
$confirmPinLabelContainer.Margin = New-Object System.Windows.Forms.Padding(0)

$confirmPinLabel = New-Object System.Windows.Forms.Label
$confirmPinLabel.Text = "Confirm PIN:"
$confirmPinLabel.ForeColor = [System.Drawing.Color]::White
$confirmPinLabel.AutoSize = $true
$confirmPinLabel.Location = New-Object System.Drawing.Point(20, 5)  # Position from left border
$confirmPinLabelContainer.Controls.Add($confirmPinLabel)
$mainLayout.Controls.Add($confirmPinLabelContainer, 0, 5)

# Confirm PIN TextBox
$confirmPinTextBoxContainer = New-Object System.Windows.Forms.Panel
$confirmPinTextBoxContainer.Dock = "Fill"
$confirmPinTextBoxContainer.Margin = New-Object System.Windows.Forms.Padding(0)

$confirmPinTextBox = New-Object System.Windows.Forms.TextBox
$confirmPinTextBox.PasswordChar = '*'
$confirmPinTextBox.Width = 430
$confirmPinTextBox.Height = 25
$confirmPinTextBox.Location = New-Object System.Drawing.Point(20, 5)  # Position from left border
$confirmPinTextBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#486581")
$confirmPinTextBox.ForeColor = [System.Drawing.Color]::White
$confirmPinTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$confirmPinTextBoxContainer.Controls.Add($confirmPinTextBox)
$mainLayout.Controls.Add($confirmPinTextBoxContainer, 0, 6)

# Status Message
$statusContainer = New-Object System.Windows.Forms.Panel
$statusContainer.Dock = "Fill"
$statusContainer.Margin = New-Object System.Windows.Forms.Padding(0)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = ""
$statusLabel.ForeColor = [System.Drawing.Color]::White
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(20, 5)  # Position from left border
$statusContainer.Controls.Add($statusLabel)
$mainLayout.Controls.Add($statusContainer, 0, 7)

# Security explanation text
$securityContainer = New-Object System.Windows.Forms.Panel
$securityContainer.Dock = "Fill"
$securityContainer.Margin = New-Object System.Windows.Forms.Padding(0)

$securityLabel = New-Object System.Windows.Forms.Label
$securityLabel.Text = "For security reasons we require you to enter a PIN to unlock the device at startup"
$securityLabel.ForeColor = [System.Drawing.Color]::White
$securityLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$securityLabel.AutoSize = $false
$securityLabel.Width = 400  # Set a fixed width to allow text wrapping
$securityLabel.Height = 40  # Increased height for wrapped text
$securityLabel.Location = New-Object System.Drawing.Point(20, 10)  # Position from left border
$securityContainer.Controls.Add($securityLabel)
$mainLayout.Controls.Add($securityContainer, 0, 8)

# Button Panel - added directly to the form
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Height = 60
$buttonPanel.Dock = "Bottom"
$buttonPanel.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#102a43")
$form.Controls.Add($buttonPanel)

# Apply Button
$applyButton = New-Object System.Windows.Forms.Button
$applyButton.Text = "Apply"
$applyButton.Width = 120
$applyButton.Height = 35
$applyButton.Location = New-Object System.Drawing.Point(230, 15)
$applyButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#486581")
$applyButton.ForeColor = [System.Drawing.Color]::White
$applyButton.FlatStyle = "Flat"
$applyButton.FlatAppearance.BorderSize = 0
$buttonPanel.Controls.Add($applyButton)

# Cancel Button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Width = 120
$cancelButton.Height = 35
$cancelButton.Location = New-Object System.Drawing.Point(360, 15)
$cancelButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#486581")
$cancelButton.ForeColor = [System.Drawing.Color]::White
$cancelButton.FlatStyle = "Flat"
$cancelButton.FlatAppearance.BorderSize = 0
$buttonPanel.Controls.Add($cancelButton)

# Get BitLocker policy settings
try {
    $MinimumPIN = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "MinimumPIN" -ErrorAction SilentlyContinue
    if ($MinimumPIN -isnot [int] -or $MinimumPIN -lt 4) {
        $MinimumPIN = 6
    }
    
    $EnhancedPIN = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseEnhancedPin" -ErrorAction SilentlyContinue
    $charType = if ($EnhancedPIN -eq 1) { "characters" } else { "digits" }
    
    $descriptionLabel.Text = "Please set up a BitLocker PIN (minimum $MinimumPIN $charType)"
} catch {
    $MinimumPIN = 6
    $EnhancedPIN = 0
    $descriptionLabel.Text = "Please set up a BitLocker PIN (minimum 6 digits)"
}

# Apply button click handler
$applyButton.Add_Click({
    # Validate PIN length
    if ($pinTextBox.Text.Length -eq 0 -or $pinTextBox.Text.Length -lt $MinimumPIN) {
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
        $statusLabel.Text = "PIN must be at least $MinimumPIN digits long"
        return
    }
    
    # Check if PIN should be numbers only
    if ($EnhancedPIN -ne 1) {
        if ($pinTextBox.Text -notmatch "^[0-9]+$") {
            $statusLabel.ForeColor = [System.Drawing.Color]::Red
            $statusLabel.Text = "PIN must contain only numeric digits"
            return
        }
    }
    
    # Check if PINs match
    if ($pinTextBox.Text -ne $confirmPinTextBox.Text) {
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
        $statusLabel.Text = "PINs do not match"
        return
    }
    
    # Check for sequential numbers
    if ((Test-IncrementNumber -NumberString $pinTextBox.Text) -or (Test-DecrementNumber -NumberString $pinTextBox.Text)) {
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
        $statusLabel.Text = "PIN is too simple (sequential digits)"
        return
    }
    
    # All validations passed - save PIN
    $statusLabel.ForeColor = [System.Drawing.Color]::LightGreen
    $statusLabel.Text = "Setting PIN..."
    
    # Encrypt and save PIN using the same key as original script
    $key = (43,155,164,59,21,127,28,43,81,18,198,145,127,51,72,55,39,23,228,166,146,237,41,131,176,14,4,67,230,81,212,214)
    $secure = ConvertTo-SecureString $pinTextBox.Text -AsPlainText -Force
    $encodedText = ConvertFrom-SecureString -SecureString $secure -Key $key
    
    $pathPINFile = $(Join-Path -Path "$env:SystemRoot\tracing" -ChildPath "168ba6df825678e4da1a.tmp")
    Out-File -FilePath $pathPINFile -InputObject $encodedText -Force
    
    $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Close()
    [Environment]::ExitCode = 0
})

# Cancel button click handler
$cancelButton.Add_Click({
    $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Close()
    [Environment]::ExitCode = 0
})

# Enter key handlers
$pinTextBox.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        $applyButton.PerformClick()
    }
})

$confirmPinTextBox.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        $applyButton.PerformClick()
    }
})

# Show the form
$form.Add_Shown({ $pinTextBox.Focus() })
$result = $form.ShowDialog()

# Set exit code
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    [Environment]::ExitCode = 0
} else {
    [Environment]::ExitCode = 0  # Also return 0 for cancel to avoid errors
}

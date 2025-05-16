# Cross-platform setup script for winwal using uv

# First, source the InstallUV script to ensure uv is available
. "$PSScriptRoot/common/InstallUV.ps1"

Write-Host "Setting up winwal with uv..."

# Create and activate a virtual environment for the project
Write-Host "Creating virtual environment..."
$envDir = "$PSScriptRoot/venv"

# Create virtual environment
& uv venv $envDir

# Activate the virtual environment
$scriptDir = $null
if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
    $scriptDir = "$envDir/Scripts/"
}
else {
    $scriptDir = "$envDir/bin/"
}

# Activate the virtual environment
& "$scriptDir/Activate.ps1"

# Install dependencies
Write-Host "Installing dependencies..."
if ($IsWindows -and ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64')) {
    & uv pip install -e ".[win32-arm64]"
}
else {
    & uv pip install -e "."
}

Write-Host "Setup complete! You can now use winwal."

# First, ensure uv is installed
. "$PSScriptRoot/InstallUV.ps1"

# Check for python or python3 command
$pythonCmd = $null
if (Get-Command 'python' -ErrorAction SilentlyContinue) {
    $pythonCmd = 'python'
}
elseif (Get-Command 'python3' -ErrorAction SilentlyContinue) {
    $pythonCmd = 'python3'
}
else {
    throw 'Python not found, please install python and add it to your PATH'
}

# Create virtual environment if it doesn't exist
$envDir = "$PSScriptRoot/../venv"
if (!(Test-Path -Path $envDir)) {
    # Use uv to create the virtual environment
    & uv venv $envDir
}

$scriptDir = $null
if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
    $scriptDir = "$envDir/Scripts/"
}
else {
    $scriptDir = "$envDir/bin/"
}

# Activate the virtual environment
& "$scriptDir/Activate.ps1"

# Install requirements with uv
if ($IsWindows -and ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64')) {
    & uv pip install -r "$PSScriptRoot/../requirements-win32-arm64.txt" 2>&1 | Out-Null
}
else {
    & uv pip install -r "$PSScriptRoot/../requirements.txt" 2>&1 | Out-Null
}
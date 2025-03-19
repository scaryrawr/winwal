# Check for python or python3 command
$pythonCmd = $null
if (Get-Command 'python' -ErrorAction SilentlyContinue) {
    $pythonCmd = 'python'
}
elseif (Get-Command 'python3' -ErrorAction SilentlyContinue) {
    $pythonCmd = 'python3'
}
else {
    throw "Python not found, please install python and add it to your PATH"
}

# Create virtual environment if it doesn't exist
$envDir = "$PSScriptRoot/../venv"
if (!(Test-Path -Path $envDir)) {
    & $pythonCmd -m venv $envDir   
}

$scriptDir = $IsWindows ? "$envDir/Scripts/" : "$envDir/bin/"

# Activate the virtual environment
& "$scriptDir/Activate.ps1"

# Install requirements, redirecting stderr to stdout to ignore already installed packages
if ($IsWindows -and ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64')) {
    pip install -r "$PSScriptRoot/../requirements-win32-arm64.txt" 2>&1 | Out-Null
}
else {
    pip install -r "$PSScriptRoot/../requirements.txt" 2>&1 | Out-Null
}
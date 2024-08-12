if (!(Get-Command 'python' -ErrorAction SilentlyContinue)) {
    throw "Python not found, please install python and add it to your PATH"
}

# Create virtual environment if it doesn't exist
$sourceDir = Split-Path $script:MyInvocation.MyCommand.Path
$envDir = "$sourceDir/venv"
if (!(Test-Path -Path $envDir)) {
    python -m venv $envDir   
}

$scriptDir = $IsWindows ? "$envDir/Scripts/" : "$envDir/bin/"

# Activate the virtual environment
& "$scriptDir/Activate.ps1"

# Install requirements, redirecting stderr to stdout to ignore already installed packages
pip install -r "$sourceDir/requirements.txt" 2>&1 | Out-Null
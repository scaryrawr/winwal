if (!(Get-Command 'python' -ErrorAction SilentlyContinue)) {
    throw "Python not found, please install python and add it to your PATH"
}

# Create virtual environment if it doesn't exist
$sourceDir = Split-Path $script:MyInvocation.MyCommand.Path
if (!(Test-Path -Path $sourceDir)) {
    python -m venv $sourceDir   
}

# Activate the virtual environment
Invoke-Expression "$sourceDir/venv/bin/Activate.ps1"

# Install requirements, redirecting stderr to stdout to ignore already installed packages
pip install -r "$sourceDir/requirements.txt" 2>&1 | Out-Null
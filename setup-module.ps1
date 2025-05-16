# setup-module.ps1 - Setup script to prepare the module

# Root directory of the module
$rootDir = $PSScriptRoot
$srcDir = Join-Path -Path $rootDir -ChildPath "src"
$commonDir = Join-Path -Path $srcDir -ChildPath "Common"

# First, import the environment module for UV installation
$environmentModule = Join-Path -Path $commonDir -ChildPath "Environment.psm1"
if (-not (Test-Path -Path $environmentModule)) {
    Write-Error "Environment module not found at: $environmentModule"
    exit 1
}

Import-Module -Name $environmentModule -Force

# Setup welcome message
Write-Host "Setting up winwal with uv..." -ForegroundColor Cyan

# Install UV if needed
try {
    Install-UV
}
catch {
    Write-Error "Failed to install uv package manager: $_"
    exit 1
}

# Create and activate virtual environment with force flag to ensure clean setup
try {
    $envActivated = Initialize-WalEnvironment -Force
}
catch {
    Write-Error "Failed to initialize Python environment: $_"
    exit 1
}

# Compile the latest requirements files
try {
    Update-RequirementFiles
}
catch {
    Write-Error "Failed to update requirement files: $_"
}

Write-Host "Setup complete! You can now use winwal by importing the module:" -ForegroundColor Green
Write-Host "    Import-Module $rootDir/winwal.psm1" -ForegroundColor Yellow
Write-Host ""
Write-Host "Or add this line to your PowerShell profile:" -ForegroundColor Green 
Write-Host "    Import-Module $rootDir/winwal.psm1" -ForegroundColor Yellow

# Deactivate the Python environment if we activated it
if ($envActivated) {
    deactivate
}

# setup.ps1 - Compatibility wrapper for setup-module.ps1

# Display migration notice
Write-Host "
NOTICE: winwal has been restructured for better maintainability.
This legacy setup script is now a wrapper for the new setup-module.ps1 script.
Consider updating your scripts to use setup-module.ps1 directly.
" -ForegroundColor Yellow

# Call the new setup script
& "$PSScriptRoot/setup-module.ps1"

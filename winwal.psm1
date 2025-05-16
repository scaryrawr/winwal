# Root directory for the module
$rootDir = $PSScriptRoot
$coreDir = Join-Path -Path $rootDir -ChildPath "src/Core"
$winDir = Join-Path -Path $rootDir -ChildPath "src/Windows" 
$commonDir = Join-Path -Path $rootDir -ChildPath "src/Common"

# Load the appropriate modules based on PowerShell version
if ($PSVersionTable.PSEdition -eq 'Core') {
    # PowerShell Core path
    Import-Module -Name (Join-Path -Path $coreDir -ChildPath "Update-WalTheme.psm1") -Force
} else {
    # Windows PowerShell path
    Import-Module -Name (Join-Path -Path $winDir -ChildPath "Update-WalTheme.psm1") -Force
}

# Import theming module for theme detection
$themingModule = Join-Path -Path $commonDir -ChildPath "Theming.psm1"
Import-Module -Name $themingModule -Force

# Export public functions from this module
Export-ModuleMember -Function Update-WalTheme, Get-CurrentTheme

# Set module metadata
$moduleVersion = "0.2.0"
$moduleDescription = "A wrapper around pywal/pywal16 for Windows and PowerShell Core"

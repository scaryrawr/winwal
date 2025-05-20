# Script to test winwal module loading and backend validation
Write-Host "Testing WinWal module..." -ForegroundColor Cyan

# Import the module (adjust path if needed)
$modulePath = Join-Path -Path $PSScriptRoot -ChildPath "winwal.psm1"
Write-Host "Importing module from: $modulePath" -ForegroundColor Yellow
Import-Module -Name $modulePath -Force -Verbose

# Get available functions
Write-Host "`nAvailable functions:" -ForegroundColor Green
Get-Command -Module winwal | Format-Table Name, CommandType

# Check if the Update-WalTheme command exists and display its parameters
Write-Host "`nParameters for Update-WalTheme:" -ForegroundColor Green
try {
    (Get-Command Update-WalTheme).Parameters | Format-Table Name, ParameterType
    Write-Host "Module loaded successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error checking Update-WalTheme parameters: $_" -ForegroundColor Red
}

# Try to get available backends
Write-Host "`nAvailable backends:" -ForegroundColor Green
try {
    & {
        # Import the BackendChecker module directly for testing
        $commonDir = Join-Path -Path $PSScriptRoot -ChildPath "src/Common"
        $backendCheckerModule = Join-Path -Path $commonDir -ChildPath "BackendChecker.psm1"
        Import-Module -Name $backendCheckerModule -Force
        
        # Call the Get-AvailableBackends function
        Get-AvailableBackends
    }
} catch {
    Write-Host "Error getting available backends: $_" -ForegroundColor Red
}

Write-Host "`nTest completed." -ForegroundColor Cyan

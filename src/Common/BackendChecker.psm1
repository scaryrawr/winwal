# BackendChecker.psm1 - Checks for available Wal backends

# Class to validate available backends for wal
class AvailableBackends : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $backends = @()
        
        # Import the environment module if needed
        if (-not (Get-Module -Name Environment)) {
            $environmentModule = Join-Path -Path $PSScriptRoot -ChildPath "Environment.psm1"
            if (Test-Path -Path $environmentModule) {
                Import-Module -Name $environmentModule
            }
            else {
                Write-Warning "Environment module not found at: $environmentModule"
                return @('wal')  # Default to wal as fallback
            }
        }
        
        # Initialize the environment and run the checker
        try {
            $envActivated = Initialize-WalEnvironment
            
            if (Get-Command 'python' -ErrorAction SilentlyContinue) {
                $rootDir = Split-Path -Path $PSScriptRoot -Parent
                $checkerScript = Join-Path -Path $rootDir -ChildPath "Core/checker.py"
                
                if (Test-Path -Path $checkerScript) {
                    $backends = ConvertTo-Json -InputObject @('colorthief', 'colorz', 'haishoku') | 
                                python $checkerScript | 
                                ConvertFrom-Json
                }
                else {
                    Write-Warning "Checker script not found at: $checkerScript"
                    $backends = @('wal')  # Default to wal as fallback
                }
            }
            
            return $backends
        }
        finally {
            # Deactivate the environment if we activated it
            if ($envActivated) {
                deactivate
            }
        }
    }
}

function Get-AvailableBackends {
    [CmdletBinding()]
    param()
    
    $validator = [AvailableBackends]::new()
    return $validator.GetValidValues()
}

Export-ModuleMember -Function Get-AvailableBackends

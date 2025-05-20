# BackendChecker.psm1 - Checks for available Wal backends

# Class to validate available backends for wal
class AvailableBackends : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $backends = @('wal')  # Always include 'wal' as default backend
        
        # Import the environment module if needed
        if (-not (Get-Module -Name Environment)) {
            $environmentModule = Join-Path -Path $PSScriptRoot -ChildPath "Environment.psm1"
            if (Test-Path -Path $environmentModule) {
                Import-Module -Name $environmentModule -Force
            }
            else {
                Write-Warning "Environment module not found at: $environmentModule"
                return $backends  # Return default backends
            }
        }
        
        # Initialize the environment and run the checker
        try {
            # Initialize the virtual environment
            Initialize-WalEnvironment
            
            if (Get-Command 'python' -ErrorAction SilentlyContinue) {
                $rootDir = Split-Path -Path $PSScriptRoot -Parent
                $checkerScript = Join-Path -Path $rootDir -ChildPath "Core/checker.py"
                
                if (Test-Path -Path $checkerScript) {
                    try {
                        $additionalBackends = ConvertTo-Json -InputObject @('colorthief', 'colorz', 'haishoku') | 
                                    python $checkerScript | 
                                    ConvertFrom-Json
                        
                        # Add any additional backends found
                        if ($additionalBackends -and $additionalBackends.Length -gt 0) {
                            $backends += $additionalBackends
                        }
                    }
                    catch {
                        Write-Warning "Error running checker script: $_"
                        # Continue with default backends
                    }
                }
                else {
                    Write-Warning "Checker script not found at: $checkerScript"
                    # Continue with default backends
                }
            }
            
            return $backends
        }
        catch {
            Write-Warning "Error checking available backends: $_"
            return @('wal')  # Return default backend on error
        }        finally {
            # Environment will be deactivated automatically when the function exits
            # No explicit deactivation needed as PowerShell handles scope cleanup
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

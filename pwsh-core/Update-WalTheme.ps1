Class AvailableBackends : System.Management.Automation.IValidateSetValuesGenerator {
  [string[]] GetValidValues() {
    $backends = @()
    & "$PSScriptRoot/../common/ConfigureVirtualEnvironment.ps1"
    try {
      if (Get-Command 'python' -ErrorAction SilentlyContinue) {
        $backends = ConvertTo-Json -InputObject @('colorthief', 'colorz', 'haishoku') | python "$PSScriptRoot/checker.py" | ConvertFrom-Json
      }

      return $backends
    }
    finally {
      deactivate
    }
  }
}

# Compatibility wrapper for legacy file structure
# This file provides backward compatibility for existing installations

# Output message about file structure change
Write-Verbose "Using legacy file structure. The winwal project has been restructured for better maintainability."

# Find the module's new location and source the new implementation
$srcDir = Join-Path -Path $PSScriptRoot -ChildPath "../src"
$corePath = Join-Path -Path $srcDir -ChildPath "Core/Update-WalTheme.psm1"

if (Test-Path -Path $corePath) {
    Import-Module -Name $corePath -Force
} else {
    Write-Warning "Could not find new module structure at $corePath. Falling back to legacy implementation."
    
    # Original implementation - kept for backward compatibility
    <#
    .DESCRIPTION
        Updates wal templates and themes using a new image or the existing desktop image
    #>
    function Update-WalTheme {
      param(
        # Path to image to set as background, if not set current wallpaper is used
        [string]$Image,
        [ValidateSet([AvailableBackends])]$Backend = 'wal'
      )

      . $PSScriptRoot/../common/Update-WalThemeInternal.ps1
      Update-WalThemeInternal -Image $Image -Backend $Backend
    }
}

Export-ModuleMember -Function Update-WalTheme
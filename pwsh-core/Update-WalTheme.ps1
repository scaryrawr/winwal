Class AvailableBackends : System.Management.Automation.IValidateSetValuesGenerator {
  [string[]] GetValidValues() {
    $backends = @()
    if (Get-Command 'python' -ErrorAction SilentlyContinue) {
      $backends = ConvertTo-Json -InputObject @('colorthief', 'colorz', 'haishoku') | python "$PSScriptRoot/checker.py" | ConvertFrom-Json
    }

    return $backends
  }
}

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

Export-ModuleMember -Function Update-WalTheme
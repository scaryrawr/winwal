<#
.DESCRIPTION
    Updates wal templates and themes using a new image or the existing desktop image
#>
function Update-WalTheme {
  param(
    # Path to image to set as background, if not set current wallpaper is used
    [string]$Image,
    [string]$Backend = 'wal'
  )

  . $PSScriptRoot/../common/Update-WalThemeInternal.ps1
  Update-WalThemeInternal -Image $Image -Backend $Backend
}

Export-ModuleMember -Function Update-WalTheme
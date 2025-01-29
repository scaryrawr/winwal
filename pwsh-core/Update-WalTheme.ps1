. $PSScriptRoot/AvailableBackends.ps1

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

  Update-WalThemeInternal -Image $Image -Backend $Backend
}
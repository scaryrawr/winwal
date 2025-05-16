# Update-WalTheme.psm1 - PowerShell Core implementation of Update-WalTheme

# Import required common module
$commonDir = Join-Path -Path $PSScriptRoot -ChildPath "../Common"
$commonWalModule = Join-Path -Path $commonDir -ChildPath "WalTheme.psm1"
$backendCheckerModule = Join-Path -Path $commonDir -ChildPath "BackendChecker.psm1"

Import-Module -Name $commonWalModule -Force
Import-Module -Name $backendCheckerModule -Force

<#
.DESCRIPTION
    Updates wal templates and themes using a new image or the existing desktop image
.PARAMETER Image
    Path to image to set as background. If not specified, current wallpaper is used.
.PARAMETER Backend
    The backend to use for color generation. Available backends depend on installed software.
.EXAMPLE
    Update-WalTheme -Image ~/Pictures/wallpaper.jpg -Backend haishoku
.EXAMPLE
    Update-WalTheme -Backend colorthief
#>
function Update-WalTheme {
    [CmdletBinding()]
    param(
        # Path to image to set as background, if not set current wallpaper is used
        [string]$Image,
        [ValidateSet([AvailableBackends])]
        [string]$Backend = 'wal'
    )

    # Call the internal implementation
    Update-WalThemeInternal -Image $Image -Backend $Backend -Verbose:$VerbosePreference
}

Export-ModuleMember -Function Update-WalTheme

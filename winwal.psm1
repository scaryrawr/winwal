if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
    . "$PSScriptRoot/windows/WinWalFunctions.ps1"
}

# Load cross-platform functions
. "$PSScriptRoot/common/WezTermFunctions.ps1"

if ($PSVersionTable.PSEdition -eq 'Core') {
    . $PSScriptRoot/pwsh-core/Update-WalTheme.ps1
}
else {
    . $PSScriptRoot/windows-pwsh/Update-WalTheme.ps1
}

Export-ModuleMember -Function Update-WalTheme, Get-CurrentTheme, Update-WalWezTerm


if ($PSVersionTable.PSEdition -eq 'Core') {
    . $PSScriptRoot/pwsh-core/Update-WalTheme.ps1
}
else {
    . $PSScriptRoot/windows-pwsh/Update-WalTheme.ps1
}

if ($IsWindows) {
    . "$PSScriptRoot/windows/WinWalFunctions.ps1"
}

Export-ModuleMember -Function Update-WalTheme, Get-CurrentTheme


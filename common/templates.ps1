<#
.DESCRIPTION
    Copies the contents of ./templates to ~/.config/wal/templates, will clobber templates with matching names
#>
function Add-WalTemplates {
  $sourceDir = "$PSScriptRoot/../templates"
  if (!(Test-Path -Path "$HOME/.config/wal/templates")) {
    New-Item -Path "$HOME/.config/wal/templates" -ItemType Directory -ErrorAction SilentlyContinue
  }

  Get-ChildItem -Path $sourceDir | ForEach-Object {
    if (!(Test-Path -Path "$HOME/.config/wal/templates/$($_.Name)")) {
      Copy-Item -Path $_.FullName -Destination "$HOME/.config/wal/templates"
    }
  }
}

Export-ModuleMember -Function Add-WalTemplates
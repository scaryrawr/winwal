function Update-WalCommandPrompt {
  $scriptDir = "$PSScriptRoot/.."
  $colorToolDir = "$scriptDir/colortool"
  $colorTool = "$colorToolDir/ColorTool.exe"
  $schemesDir = "$colorToolDir/schemes/"

  # Install color tool if needed
  if (!(Test-Path -Path $colorTool)) {
    $colorToolZip = "$scriptDir/colortool.zip"
    Invoke-WebRequest -Uri "https://github.com/microsoft/terminal/releases/download/1904.29002/ColorTool.zip" -OutFile $colorToolZip
    Expand-Archive -Path $colorToolZip -DestinationPath $colorToolDir
    Remove-Item -Path $colorToolZip
  }
    
  # Make sure it was created
  $walprompt = "$HOME/.cache/wal/wal-prompt.ini"
  if (Test-Path -Path $walprompt) {
    Copy-Item -Path $walprompt -Destination "$schemesDir/wal.ini"
    & $colorTool -b wal.ini
  }
}

function Update-WalTerminal {
  if (!(Test-Path -Path "$HOME/.cache/wal/windows-terminal.json")) {
    return
  }

  @(
    # Stable
    "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState", 

    # Preview
    "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState",

    # Stable - Scoop
    "$HOME/scoop/persist/windows-terminal/settings",

    # Preview - Scoop
    "$HOME/scoop/persist/windows-terminal-preview/settings"
  ) | ForEach-Object {
    $terminalDir = "$_"
    $terminalProfile = "$terminalDir/settings.json"

    # This version of windows terminal isn't installed
    if (!(Test-Path -Path $terminalProfile)) {
      return
    }

    Copy-Item -Path $terminalProfile -Destination "$terminalDir/settings.json.bak"

    # Load existing profile
    $configData = (Get-Content -Path $terminalProfile | ConvertFrom-Json) | Where-Object { $_ -ne $null }

    # Create a new list to store schemes
    $schemes = New-Object Collections.Generic.List[Object]

    $configData.schemes | Where-Object { $_.name -ne "wal" } | ForEach-Object { $schemes.Add($_) }
    $walTheme = $(Get-Content "$HOME/.cache/wal/windows-terminal.json" | ConvertFrom-Json)
    $schemes.Add($walTheme)

    # Update color schemes
    $configData.schemes = $schemes

    # Set default theme as wal
    $configData.profiles.defaults | Add-Member -MemberType NoteProperty -Name colorScheme -Value 'wal' -Force

    # Set cursor to foreground color
    $configData.profiles.defaults | Add-Member -MemberType NoteProperty -Name cursorColor -Value $walTheme.foreground -Force

    # Write config to disk
    $configData | ConvertTo-Json -Depth 32 | Set-Content -Path $terminalProfile
  }
}

Export-ModuleMember -Function Update-WalCommandPrompt, Update-WalTerminal
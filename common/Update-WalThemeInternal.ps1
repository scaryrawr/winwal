<#
.DESCRIPTION
    Updates wal templates and themes using a new image or the existing desktop image
#>
function Get-UserOhMyPoshConfigPath {
  $profileCandidates = @(
    $PROFILE.CurrentUserCurrentHost,
    $PROFILE.CurrentUserAllHosts,
    $PROFILE
  ) | Where-Object { $_ } | Select-Object -Unique

  $configPattern = '(?im)^\s*(?!#).*?\boh-my-posh\s+init\s+pwsh\b[^\r\n]*?(?:--config|-c)\s*(?:=|\s+)(?:"(?<config>[^"]+)"|''(?<config>[^'']+)''|(?<config>[^\s|;]+))'

  foreach ($profilePath in $profileCandidates) {
    if (-not (Test-Path -Path $profilePath)) {
      continue
    }

    $profileContent = Get-Content -Path $profilePath -Raw -ErrorAction SilentlyContinue
    if (-not $profileContent) {
      continue
    }

    $match = [regex]::Match($profileContent, $configPattern)
    if (-not $match.Success) {
      continue
    }

    $rawConfigPath = $match.Groups['config'].Value.Trim()
    if (-not $rawConfigPath) {
      continue
    }

    if ($rawConfigPath.StartsWith('~')) {
      $rawConfigPath = $rawConfigPath -replace '^~', $HOME
    }

    $expandedConfigPath = $ExecutionContext.InvokeCommand.ExpandString($rawConfigPath)
    if (Test-Path -Path $expandedConfigPath) {
      return $expandedConfigPath
    }
  }

  return $null
}

function Update-WalThemeInternal {
  param(
    # Path to image to set as background, if not set current wallpaper is used
    [string]$Image,
    [string]$Backend = 'wal'
  )

  # Determine image
  $img = $Image
  if (-not $img) {
    $img = (Get-ItemProperty -Path 'HKCU:/Control Panel/Desktop' -Name Wallpaper).Wallpaper
  }

  . $PSScriptRoot/templates.ps1
  # Add our templates to wal configuration
  Add-WalTemplates

  $tempImg = "$env:TEMP/$(Split-Path $img -Leaf)"

  # Use temp location, default backgrounds are in a write protected directory
  if (-not (Test-Path -Path $tempImg)) {
    Copy-Item -Path $img -Destination $tempImg
  }

  if (Get-Command 'wal' -ErrorAction SilentlyContinue) {
    . $PSScriptRoot/theming.ps1
    # Retrieve current theme using the new function
    $currentTheme = Get-CurrentTheme

    # Construct wal arguments
    $walArgs = @('-e', '-s', '-t', '-i', $tempImg, '--backend', $Backend)
    if ($img) {
      $walArgs += '-n'
    }
    if ($currentTheme -eq 'Light') {
      $walArgs += '-l'
    }

    # Invoke wal with constructed arguments
    wal @walArgs
  }
  else {
    Write-Error "Pywal not found, please install python and pywal and add it to your PATH`n`twinget install Python.Python.3.11`n`tpip install pywal"
    return
  }

  # Return if wal failed
  if ($LastExitCode -ne 0) {
    return
  }

  # Update Windows Terminal
  if (Get-Command 'Update-WalTerminal' -ErrorAction SilentlyContinue) {
    Update-WalTerminal
  }
  
  if (Get-Command 'Update-WalCommandPrompt' -ErrorAction SilentlyContinue) {
    Update-WalCommandPrompt
  }

  # New oh-my-posh
  if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $defaultOhMyPoshConfig = "$HOME/.cache/wal/posh-wal-agnoster.omp.json"
    $ohMyPoshConfig = Get-UserOhMyPoshConfigPath

    if (-not $ohMyPoshConfig -and (Test-Path -Path $defaultOhMyPoshConfig)) {
      $ohMyPoshConfig = $defaultOhMyPoshConfig
    }

    if ($ohMyPoshConfig) {
      oh-my-posh init pwsh --config $ohMyPoshConfig | Invoke-Expression
    }
  }

  # Check if pywal fox needs to update
  if (Get-Command pywalfox -ErrorAction SilentlyContinue) {
    pywalfox update
  }

  # Terminal Icons
  if ((Get-Module -ListAvailable -Name Terminal-Icons) -and (Test-Path -Path "$HOME/.cache/wal/wal-icons.psd1")) {
    Add-TerminalIconsColorTheme -Path "$HOME/.cache/wal/wal-icons.psd1"
    Set-TerminalIconsTheme -ColorTheme wal
  }
}

Export-ModuleMember -Function Update-WalThemeInternal
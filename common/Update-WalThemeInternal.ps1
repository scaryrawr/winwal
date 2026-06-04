<#
.DESCRIPTION
    Updates wal templates and themes using a new image or the existing desktop image
#>
function Get-WalCurrentWallpaper {
  $wallpaper = (Get-ItemProperty -Path 'HKCU:/Control Panel/Desktop' -Name Wallpaper -ErrorAction SilentlyContinue).Wallpaper

  if ((-not $wallpaper) -or (Test-WalTranscodedWallpaperPath -Path $wallpaper)) {
    $cachedWallpaper = Get-WalTranscodedImageCacheWallpaper
    if ($cachedWallpaper) {
      return $cachedWallpaper
    }
  }

  return $wallpaper
}

function Test-WalTranscodedWallpaperPath {
  param(
    [string]$Path
  )

  if (-not $Path) {
    return $false
  }

  return ($Path -replace '/', '\') -like '*\Microsoft\Windows\Themes\TranscodedWallpaper*'
}

function Get-WalTranscodedImageCacheWallpaper {
  $cache = (Get-ItemProperty -Path 'HKCU:/Control Panel/Desktop' -Name TranscodedImageCache -ErrorAction SilentlyContinue).TranscodedImageCache
  if (-not $cache) {
    return $null
  }

  $decoded = [System.Text.Encoding]::Unicode.GetString($cache)
  $imageExtensions = 'jpg|jpeg|png|bmp|gif|webp|tiff|tif|heic|heif|avif'
  $pathPattern = "(?i)(?:[A-Z]:|\\\\[^\\/:*?`"<>|`0]+\\[^\\/:*?`"<>|`0]+)\\(?:[^\\/:*?`"<>|`0]+\\)*[^\\/:*?`"<>|`0]+\.(?:$imageExtensions)"
  $matches = [regex]::Matches($decoded, $pathPattern)

  if ($matches.Count -eq 0) {
    return $null
  }

  foreach ($match in $matches) {
    if (Test-Path -LiteralPath $match.Value -PathType Leaf) {
      return $match.Value
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
    $img = Get-WalCurrentWallpaper
  }

  if (-not $img) {
    Write-Error 'No image path specified and current wallpaper could not be detected.'
    return
  }

  . $PSScriptRoot/templates.ps1
  # Add our templates to wal configuration
  Add-WalTemplates

  $tempImg = Join-Path -Path $env:TEMP -ChildPath (Split-Path -Path $img -Leaf)

  # Use temp location, default backgrounds are in a write protected directory
  if ($img -ne $tempImg) {
    Copy-Item -LiteralPath $img -Destination $tempImg -Force
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
  if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (Test-Path -Path "$HOME/.cache/wal/posh-wal-agnoster.omp.json")) {
    oh-my-posh init pwsh --config "$HOME/.cache/wal/posh-wal-agnoster.omp.json" | Invoke-Expression
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

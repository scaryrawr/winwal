function Update-WalWezTerm {
  # Check if the wal-wezterm theme file was generated
  if (!(Test-Path -Path "$HOME/.cache/wal/wal-wezterm.toml")) {
    return
  }

  # Common WezTerm config locations across platforms
  $wezTermConfigDirs = @()
  
  if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
    # Windows locations
    $wezTermConfigDirs += @(
      "$env:APPDATA\wezterm",
      "$HOME\.config\wezterm"
    )
  } else {
    # Unix-like systems (Linux, macOS)
    $wezTermConfigDirs += @(
      "$HOME/.config/wezterm"
    )
  }

  foreach ($configDir in $wezTermConfigDirs) {
    # Check if this config directory exists or try to create it
    if (!(Test-Path -Path $configDir -PathType Container)) {
      try {
        New-Item -Path $configDir -ItemType Directory -Force -ErrorAction Stop | Out-Null
      }
      catch {
        continue
      }
    }

    # Create colors subdirectory if it doesn't exist
    $colorsDir = Join-Path -Path $configDir -ChildPath "colors"
    if (!(Test-Path -Path $colorsDir -PathType Container)) {
      try {
        New-Item -Path $colorsDir -ItemType Directory -Force -ErrorAction Stop | Out-Null
      }
      catch {
        Write-Warning "Failed to create colors directory at $colorsDir"
        continue
      }
    }

    # Copy the wal-wezterm theme to the colors directory
    $destThemePath = Join-Path -Path $colorsDir -ChildPath "wal.toml"
    try {
      Copy-Item -Path "$HOME/.cache/wal/wal-wezterm.toml" -Destination $destThemePath -Force
      Write-Host "Updated WezTerm color scheme: $destThemePath"
    }
    catch {
      Write-Warning "Failed to copy WezTerm color scheme to $destThemePath : $_"
      continue
    }

    # Check if main config file exists and optionally update it to use wal color scheme
    $configPath = Join-Path -Path $configDir -ChildPath "wezterm.lua"
    if (Test-Path -Path $configPath) {
      try {
        # Backup existing config
        $backupPath = "$configPath.bak"
        Copy-Item -Path $configPath -Destination $backupPath -Force

        # Read current config
        $currentConfig = Get-Content -Path $configPath -Raw

        # Check if config already references wal color scheme
        if ($currentConfig -notmatch 'color_scheme.*=.*[''"]wal[''"]') {
          # Only update if there's no existing color_scheme setting or if it's not already set to wal
          if ($currentConfig -match 'config\.color_scheme\s*=') {
            # Replace existing color_scheme assignment with wal
            $pattern = "config\.color_scheme\s*=\s*[^\r\n]+"
            $replacement = "config.color_scheme = `"wal`""
            $newConfig = $currentConfig -replace $pattern, $replacement
          } elseif ($currentConfig -match 'return\s+config') {
            # Add color_scheme assignment before the return statement
            $newConfig = $currentConfig -replace '(return\s+config)', "config.color_scheme = `"wal`"`n`n`$1"
          } else {
            # Config exists but doesn't follow standard pattern, leave it alone
            Write-Host "WezTerm config exists but doesn't follow standard pattern. Color scheme file updated, but config not modified: $configPath"
            continue
          }

          # Write the updated config
          Set-Content -Path $configPath -Value $newConfig -Encoding UTF8
          Write-Host "Updated WezTerm config to use wal color scheme: $configPath"
        } else {
          Write-Host "WezTerm config already uses wal color scheme: $configPath"
        }
      }
      catch {
        Write-Warning "Failed to update WezTerm config at $configPath : $_"
        # Restore backup if something went wrong
        if (Test-Path -Path $backupPath) {
          Copy-Item -Path $backupPath -Destination $configPath -Force
        }
      }
    } else {
      # Create a basic config file that uses the wal color scheme
      try {
        $basicConfig = @"
local config = {}

-- Use wal color scheme
config.color_scheme = "wal"

return config
"@
        Set-Content -Path $configPath -Value $basicConfig -Encoding UTF8
        Write-Host "Created WezTerm config with wal color scheme: $configPath"
      }
      catch {
        Write-Warning "Failed to create WezTerm config at $configPath : $_"
      }
    }
  }
}

Export-ModuleMember -Function Update-WalWezTerm
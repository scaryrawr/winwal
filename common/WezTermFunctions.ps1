function Update-WalWezTerm {
  if (!(Test-Path -Path "$HOME/.cache/wal/wezterm.lua")) {
    return
  }

  # Common WezTerm config locations across platforms
  $wezTermConfigs = @()
  
  if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
    # Windows locations
    $wezTermConfigs += @(
      "$env:APPDATA\wezterm\wezterm.lua",
      "$HOME\.config\wezterm\wezterm.lua", 
      "$HOME\.wezterm.lua"
    )
  } else {
    # Unix-like systems (Linux, macOS)
    $wezTermConfigs += @(
      "$HOME/.config/wezterm/wezterm.lua",
      "$HOME/.wezterm.lua"
    )
  }

  foreach ($configPath in $wezTermConfigs) {
    $configDir = Split-Path -Path $configPath -Parent
    
    # Skip if this is a config path that doesn't make sense for current platform
    if ($configDir -and !(Test-Path -Path $configDir -PathType Container)) {
      # Try to create the directory, if it fails then this location isn't valid
      try {
        New-Item -Path $configDir -ItemType Directory -Force -ErrorAction Stop | Out-Null
      }
      catch {
        continue
      }
    }

    # Check if this config path already exists or if its parent directory exists/was created
    if (!(Test-Path -Path $configPath) -and !(Test-Path -Path $configDir -PathType Container)) {
      continue
    }

    # Backup existing config
    $backupPath = "$configPath.bak"
    if (Test-Path -Path $configPath) {
      Copy-Item -Path $configPath -Destination $backupPath -Force
    }

    try {
      # Read current config
      $currentConfig = ""
      if (Test-Path -Path $configPath) {
        $currentConfig = Get-Content -Path $configPath -Raw
      }

      # Read the generated wal color scheme
      $walScheme = Get-Content -Path "$HOME/.cache/wal/wezterm.lua" -Raw

      # Check if we need to add or replace the wal color scheme
      $walSchemePattern = '(?s)local\s+wal_scheme\s*=.*?return\s+wal_scheme'
      $walRequirePattern = 'local\s+wal_scheme\s*=\s*require\s*\(\s*[''"]wal[''"]?\s*\)'
      
      # Remove any existing wal scheme definitions
      $newConfig = $currentConfig -replace $walSchemePattern, ''
      $newConfig = $newConfig -replace $walRequirePattern, ''
      
      # If the config is empty or only whitespace, initialize it
      if ([string]::IsNullOrWhiteSpace($newConfig)) {
        $newConfig = @"
local config = {}

$walScheme

-- Set the color scheme to wal
config.color_scheme = wal_scheme

return config
"@
      } else {
        # If config exists, prepend the wal scheme and ensure it's being used
        # First check if there's already a color_scheme assignment
        if ($newConfig -match 'config\.color_scheme\s*=') {
          # Replace existing color_scheme assignment
          $newConfig = $newConfig -replace 'config\.color_scheme\s*=.*', 'config.color_scheme = wal_scheme'
        } else {
          # Add color_scheme assignment before the return statement
          $newConfig = $newConfig -replace '(return\s+config)', "config.color_scheme = wal_scheme`n`n`$1"
        }
        
        # Prepend the wal scheme at the top
        $newConfig = "$walScheme`n`n$newConfig"
      }

      # Write the updated config
      Set-Content -Path $configPath -Value $newConfig -Encoding UTF8
      
      Write-Host "Updated WezTerm config: $configPath"
    }
    catch {
      Write-Warning "Failed to update WezTerm config at $configPath : $_"
      # Restore backup if something went wrong
      if (Test-Path -Path $backupPath) {
        Copy-Item -Path $backupPath -Destination $configPath -Force
      }
    }
  }
}

Export-ModuleMember -Function Update-WalWezTerm
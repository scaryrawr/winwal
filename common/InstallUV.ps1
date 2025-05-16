# Script to install uv if not already installed
function Install-UV {
  # Check if uv is already installed
  $uvInstalled = $false
  try {
    $null = & uv --version
    $uvInstalled = $true
  }
  catch {
    $uvInstalled = $false
  }

  if (-not $uvInstalled) {
    Write-Host 'Installing uv package manager...'
        
    # Install based on platform
    if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
      # Windows installation
      try {
        powershell -ExecutionPolicy ByPass -c 'irm https://astral.sh/uv/install.ps1 | iex'
      }
      catch {
        Write-Error "Failed to install uv: $_"
        throw 'Failed to install uv. Please install manually from https://github.com/astral-sh/uv'
      }
    }
    elseif ($IsMacOS -or $IsLinux) {
      # macOS and Linux installation
      try {
        # Check if we have curl
        if (Get-Command 'curl' -ErrorAction SilentlyContinue) {
          & curl -LsSf https://astral.sh/uv/install.sh | sh
        }
        else {
          throw 'curl is not installed. Please install uv manually from https://github.com/astral-sh/uv'
        }
      }
      catch {
        Write-Error "Failed to install uv: $_"
        throw 'Failed to install uv. Please install manually from https://github.com/astral-sh/uv'
      }
    }
    else {
      throw 'Unsupported platform. Please install uv manually from https://github.com/astral-sh/uv'
    }

    # Verify installation
    try {
      $null = & uv --version
      Write-Host 'uv installed successfully'
    }
    catch {
      throw 'uv installation failed or uv is not in PATH'
    }
  }
  else {
    Write-Host 'uv is already installed'
  }
}

# Run the installation function
Install-UV

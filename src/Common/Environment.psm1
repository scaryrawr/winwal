# Environment.psm1 - Manages the Python environment setup

# Function to ensure uv is installed
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

# Function to set up the Python virtual environment
function Initialize-WalEnvironment {
  [CmdletBinding()]
  param(
    [switch]$Force
  )

  # First, ensure uv is installed
  Install-UV

  $rootDir = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
  $envDir = Join-Path -Path $rootDir -ChildPath "venv"
  $activated = $false
  
  # Check if the environment already exists and if we need to recreate it
  if ((Test-Path -Path $envDir) -and -not $Force) {
    Write-Verbose "Using existing virtual environment at $envDir"
  }
  else {
    if ($Force -and (Test-Path -Path $envDir)) {
      Write-Verbose "Removing existing virtual environment"
      Remove-Item -Path $envDir -Recurse -Force
    }
    
    Write-Verbose "Creating new virtual environment at $envDir"
    & uv venv $envDir
    $activated = $false  # Force reactivation
  }

  # Determine script directory based on platform
  $scriptDir = $null
  if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
    $scriptDir = Join-Path -Path $envDir -ChildPath "Scripts"
  }
  else {
    $scriptDir = Join-Path -Path $envDir -ChildPath "bin"
  }

  # Activate the virtual environment if not already activated
  $activateScript = Join-Path -Path $scriptDir -ChildPath "Activate.ps1"
  if ((Test-Path -Path $activateScript) -and (-not $activated)) {
    Write-Verbose "Activating virtual environment"
    & $activateScript
    $activated = $true
  }

  # Install required packages
  Write-Verbose "Installing dependencies"
  if ($IsWindows -and ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64')) {
    & uv pip install -r (Join-Path -Path $rootDir -ChildPath "requirements-win32-arm64.txt")
  }
  else {
    & uv pip install -r (Join-Path -Path $rootDir -ChildPath "requirements.txt")
  }

  return $activated
}

# Function to compile requirement files
function Update-RequirementFiles {
  [CmdletBinding()]
  param()

  # Ensure uv is installed
  Install-UV

  $rootDir = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
  
  # Compile main requirements file
  Write-Verbose "Compiling main requirements file"
  & uv pip compile (Join-Path -Path $rootDir -ChildPath "requirements.in") --output-file (Join-Path -Path $rootDir -ChildPath "requirements.txt") --universal

  # Compile ARM64 requirements file if it exists
  $armReqIn = Join-Path -Path $rootDir -ChildPath "requirements-win32-arm64.in"
  if (Test-Path -Path $armReqIn) {
    Write-Verbose "Compiling ARM64 requirements file"
    & uv pip compile $armReqIn --output-file (Join-Path -Path $rootDir -ChildPath "requirements-win32-arm64.txt") --universal
  }
  
  Write-Verbose "Requirements compilation complete"
}

Export-ModuleMember -Function Initialize-WalEnvironment, Update-RequirementFiles

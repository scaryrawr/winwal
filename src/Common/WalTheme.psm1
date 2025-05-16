# WalTheme.psm1 - Core implementation of update-waltheme

function Update-WalThemeInternal {
    [CmdletBinding()]
    param(
        # Path to image to set as background, if not set current wallpaper is used
        [string]$Image,
        [string]$Backend = 'wal'
    )

    # Get root module path
    $rootDir = Split-Path -Path $PSScriptRoot -Parent
    $commonDir = Join-Path -Path $rootDir -ChildPath "Common"

    # Import required modules
    $environmentModule = Join-Path -Path $commonDir -ChildPath "Environment.psm1"
    $themingModule = Join-Path -Path $commonDir -ChildPath "Theming.psm1"
    $templatesModule = Join-Path -Path $commonDir -ChildPath "Templates.psm1"

    # Load the modules
    Import-Module -Name $environmentModule -Force
    Import-Module -Name $themingModule -Force
    Import-Module -Name $templatesModule -Force

    # Setup environment
    $envActivated = $false
    try {
        $envActivated = Initialize-WalEnvironment
        
        # Determine the image to use
        $img = $Image
        if (-not $img) {
            if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
                $img = (Get-ItemProperty -Path 'HKCU:/Control Panel/Desktop' -Name Wallpaper).Wallpaper
            }
        }

        if (-not $img -or -not (Test-Path -Path $img)) {
            Write-Error "No valid image provided and couldn't determine current wallpaper"
            return
        }

        # Add our templates to wal configuration
        Add-WalTemplates

        # Use temp location for the image (default backgrounds may be in a write-protected directory)
        $tempImg = Join-Path -Path $env:TEMP -ChildPath (Split-Path -Path $img -Leaf)
        if (-not (Test-Path -Path $tempImg)) {
            Copy-Item -Path $img -Destination $tempImg
        }

        if (Get-Command 'wal' -ErrorAction SilentlyContinue) {
            # Retrieve current theme
            $currentTheme = Get-CurrentTheme

            # Construct wal arguments
            $walArgs = @('-e', '-s', '-t', '-i', $tempImg, '--backend', $Backend)
            if ($img) {
                $walArgs += '-n'
            }
            if ($currentTheme -eq 'Light') {
                $walArgs += '-l'
            }

            Write-Verbose "Running wal with arguments: $walArgs"
            & wal @walArgs
        }
        else {
            Write-Error @"
Pywal not found, please install python and pywal and add it to your PATH
    winget install Python.Python.3.11
    pip install pywal
"@
            return
        }

        # If wal failed, stop
        if ($LastExitCode -ne 0) {
            Write-Error "Wal command failed with exit code: $LastExitCode"
            return
        }

        # Platform-specific updates
        if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
            $windowsModulePath = Join-Path -Path $rootDir -ChildPath "Windows/WinWalFunctions.psm1"
            if (Test-Path -Path $windowsModulePath) {
                Import-Module -Name $windowsModulePath -Force
                
                # Update Windows Terminal if function exists
                if (Get-Command 'Update-WalTerminal' -ErrorAction SilentlyContinue) {
                    Update-WalTerminal
                }
                
                # Update Command Prompt if function exists
                if (Get-Command 'Update-WalCommandPrompt' -ErrorAction SilentlyContinue) {
                    Update-WalCommandPrompt
                }
            }
        }

        # Update oh-my-posh
        $ompThemePath = Join-Path -Path $HOME -ChildPath ".cache/wal/posh-wal-agnoster.omp.json"
        if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (Test-Path -Path $ompThemePath)) {
            Write-Verbose "Updating oh-my-posh theme"
            oh-my-posh init pwsh --config $ompThemePath | Invoke-Expression
        }

        # Check if pywal fox needs to update
        if (Get-Command pywalfox -ErrorAction SilentlyContinue) {
            Write-Verbose "Updating pywalfox"
            pywalfox update
        }

        # Terminal Icons
        $walIconsPath = Join-Path -Path $HOME -ChildPath ".cache/wal/wal-icons.psd1"
        if ((Get-Module -ListAvailable -Name Terminal-Icons) -and (Test-Path -Path $walIconsPath)) {
            Write-Verbose "Updating Terminal-Icons theme"
            Add-TerminalIconsColorTheme -Path $walIconsPath -ErrorAction SilentlyContinue
            Set-TerminalIconsTheme -ColorTheme wal -ErrorAction SilentlyContinue
        }

        Write-Host "Wal theme updated successfully" -ForegroundColor Green
    }
    catch {
        Write-Error "An error occurred: $_"
    }
    finally {
        # Deactivate the environment if we activated it
        if ($envActivated) {
            Write-Verbose "Deactivating Python environment"
            deactivate
        }
    }
}

Export-ModuleMember -Function Update-WalThemeInternal

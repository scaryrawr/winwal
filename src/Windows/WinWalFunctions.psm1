# WinWalFunctions.psm1 - Windows-specific terminal configuration functions

function Update-WalCommandPrompt {
    [CmdletBinding()]
    param()
    
    $rootDir = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $colorToolDir = Join-Path -Path $rootDir -ChildPath "colortool"
    $colorTool = Join-Path -Path $colorToolDir -ChildPath "ColorTool.exe"
    $schemesDir = Join-Path -Path $colorToolDir -ChildPath "schemes"

    # Install color tool if needed
    if (!(Test-Path -Path $colorTool)) {
        Write-Verbose "ColorTool not found. Installing..."
        $colorToolZip = Join-Path -Path $rootDir -ChildPath "colortool.zip"
        Invoke-WebRequest -Uri "https://github.com/microsoft/terminal/releases/download/1904.29002/ColorTool.zip" -OutFile $colorToolZip
        Expand-Archive -Path $colorToolZip -DestinationPath $colorToolDir
        Remove-Item -Path $colorToolZip
    }
        
    # Make sure the wal prompt file was created
    $walprompt = Join-Path -Path $HOME -ChildPath ".cache/wal/wal-prompt.ini"
    if (Test-Path -Path $walprompt) {
        Write-Verbose "Setting command prompt colors using ColorTool"
        Copy-Item -Path $walprompt -Destination (Join-Path -Path $schemesDir -ChildPath "wal.ini")
        & $colorTool -b "wal.ini"
    }
    else {
        Write-Warning "wal-prompt.ini not found, skipping command prompt theming"
    }
}

function Update-WalTerminal {
    [CmdletBinding()]
    param()
    
    $walThemePath = Join-Path -Path $HOME -ChildPath ".cache/wal/windows-terminal.json"
    if (!(Test-Path -Path $walThemePath)) {
        Write-Warning "windows-terminal.json not found in wal cache, skipping terminal update"
        return
    }

    # Terminal installation paths to check
    $terminalPaths = @(
        # Stable - Windows Store
        (Join-Path -Path $HOME -ChildPath "AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"), 

        # Preview - Windows Store
        (Join-Path -Path $HOME -ChildPath "AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState"),

        # Stable - Scoop
        (Join-Path -Path $HOME -ChildPath "scoop/persist/windows-terminal/settings"),

        # Preview - Scoop
        (Join-Path -Path $HOME -ChildPath "scoop/persist/windows-terminal-preview/settings")
    )

    $terminalUpdated = $false
    foreach ($terminalDir in $terminalPaths) {
        $terminalProfile = Join-Path -Path $terminalDir -ChildPath "settings.json"

        # This version of windows terminal isn't installed
        if (!(Test-Path -Path $terminalProfile)) {
            Write-Verbose "Terminal settings not found at: $terminalProfile"
            continue
        }

        try {
            Write-Verbose "Updating terminal settings at: $terminalProfile"
            # Backup existing profile
            $backupPath = Join-Path -Path $terminalDir -ChildPath "settings.json.bak" 
            Copy-Item -Path $terminalProfile -Destination $backupPath -Force

            # Load existing profile
            $configData = Get-Content -Path $terminalProfile | ConvertFrom-Json
            if ($null -eq $configData) {
                Write-Warning "Could not parse terminal settings file: $terminalProfile"
                continue
            }

            # Create a new list to store schemes
            $schemes = New-Object Collections.Generic.List[Object]

            # Remove any existing 'wal' scheme and add all other schemes
            $configData.schemes | Where-Object { $_.name -ne "wal" } | ForEach-Object { 
                $schemes.Add($_) 
            }
            
            # Add the new wal theme
            $walTheme = Get-Content -Path $walThemePath | ConvertFrom-Json
            $schemes.Add($walTheme)

            # Update color schemes
            $configData.schemes = $schemes

            # Set default theme as wal
            if ($null -eq $configData.profiles.defaults) {
                $configData.profiles | Add-Member -MemberType NoteProperty -Name defaults -Value @{} -Force
            }
            $configData.profiles.defaults | Add-Member -MemberType NoteProperty -Name colorScheme -Value 'wal' -Force

            # Set cursor to foreground color
            $configData.profiles.defaults | Add-Member -MemberType NoteProperty -Name cursorColor -Value $walTheme.foreground -Force

            # Write config to disk
            $configData | ConvertTo-Json -Depth 32 | Set-Content -Path $terminalProfile
            $terminalUpdated = $true
            
            Write-Verbose "Terminal settings updated successfully"
        }
        catch {
            Write-Warning "Failed to update terminal settings at $terminalProfile: $_"
            # Try to restore backup if available
            if (Test-Path -Path $backupPath) {
                Write-Verbose "Restoring backup settings"
                Copy-Item -Path $backupPath -Destination $terminalProfile -Force
            }
        }
    }

    if (-not $terminalUpdated) {
        Write-Warning "No Windows Terminal installations were found or could be updated"
    }
}

Export-ModuleMember -Function Update-WalCommandPrompt, Update-WalTerminal

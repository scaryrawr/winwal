<#
.DESCRIPTION
    Updates the desktop wallpaper.
#>
function Set-Wallpaper {
    param(
        # Path to image to set as background, if not set current wallpaper is used
        [Parameter(Mandatory = $true)][string]$Image
    )

    # Trigger update of wallpaper
    # modified from https://www.joseespitia.com/2017/09/15/set-wallpaper-powershell-function/
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class PInvoke
{
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo(UInt32 action, UInt32 iParam, String sParam, UInt32 winIniFlags);
}
"@

    # Setting the wallpaper requires an absolute path, so pass image into resolve-path
    [PInvoke]::SystemParametersInfo(0x0014, 0, $($Image | Resolve-Path), 0x0003) -eq 1
}

<#
.DESCRIPTION
    Gets the location of the module.
#>
function Get-ScriptDirectory {
    Split-Path $script:MyInvocation.MyCommand.Path
}

<#
.DESCRIPTION
    Copies the contents of ./templates to ~/.config/wal/templates, will clobber templates with matching names
#>
function Add-WalTemplates {
    $sourceDir = "$(Get-ScriptDirectory)/templates"
    if (!(Test-Path -Path "$HOME/.config/wal/templates")) {
        New-Item -Path "$HOME/.config/wal/templates" -ItemType Directory -ErrorAction SilentlyContinue
    }

    Get-ChildItem -Path $sourceDir | ForEach-Object {
        if (!(Test-Path -Path "$HOME/.config/wal/templates/$($_.Name)")) {
            Copy-Item -Path $_.FullName -Destination "$HOME/.config/wal/templates"
        }
    }
}

function Update-WalCommandPrompt {
    $scriptDir = Get-ScriptDirectory
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
        "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState"
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

Class AvailableBackends : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $backends = @()
        if (Get-Command 'python' -ErrorAction SilentlyContinue) {
            $backends = ConvertTo-Json -InputObject @('colorthief', 'colorz', 'haishoku') | python "$(Get-ScriptDirectory)/checker.py" | ConvertFrom-Json
        }

        return $backends
    }
}

<#
.DESCRIPTION
    Updates wal templates and themes using a new image or the existing desktop image
#>
function Update-WalTheme {
    param(
        # Path to image to set as background, if not set current wallpaper is used
        [string]$Image,
        [ValidateSet([AvailableBackends])]$Backend = 'colorthief'
    )

    $img = (Get-ItemProperty -Path 'HKCU:/Control Panel/Desktop' -Name Wallpaper).Wallpaper
    if ($Image) {
        $img = $Image
    }

    # Add our templates to wal configuration
    Add-WalTemplates

    $tempImg = "$env:TEMP/$(Split-Path $img -leaf)"

    # Use temp location, default backgrounds are in a write protected directory
    Copy-Item -Path $img -Destination $tempImg

    if (Get-Command 'wal.exe' -ErrorAction SilentlyContinue) {
        # Invoke wal with colorthief backend and don't set the wallpaper (wal will fail)
        $light = $(Get-ItemProperty -Path 'HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize' -Name AppsUseLightTheme).AppsUseLightTheme
        if ($light -gt 0) {
            wal -n -e -l -s -t -i $tempImg --backend $Backend
        }
        else {
            wal -n -e -s -t -i $tempImg --backend $Backend
        }
    }
    else {
        Write-Error "Pywal not found, please install python and pywal and add it to your PATH`n`twinget install Python.Python.3.11`n`tpip install pywal"
        return
    }

    # Set the wallpaper
    if ($Image) {
        Set-Wallpaper -Image $Image
    }

    # Update Windows Terminal
    Update-WalTerminal

    # Update prompt defaults
    Update-WalCommandPrompt

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

# Theming.psm1 - Provides theme detection functions

function Get-CurrentTheme {
    [CmdletBinding()]
    param()
    
    $os = if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
        'Windows'
    } elseif ($IsLinux) {
        'Linux'
    } else {
        'MacOS'
    }

    switch ($os) {
        'Windows' {
            try {
                $themeValue = (Get-ItemProperty -Path 'HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize' -Name AppsUseLightTheme -ErrorAction Stop).AppsUseLightTheme
                if ($themeValue -gt 0) {
                    return 'Light'
                } else {
                    return 'Dark'
                }
            }
            catch {
                Write-Warning "Could not determine Windows theme: $_"
                return 'Dark' # Default to dark theme if we can't determine
            }
        }
        'Linux' {
            try {
                $gtkTheme = & gsettings get org.gnome.desktop.interface gtk-theme 2>$null
                if ($gtkTheme -match 'dark') {
                    return 'Dark'
                }
                else {
                    return 'Light'
                }
            }
            catch {
                Write-Warning "Could not determine Linux theme: $_"
                return 'Dark'
            }
        }
        'MacOS' {
            try {
                $preferences = & defaults read -g AppleInterfaceStyle 2>$null
                if ($preferences -eq 'Dark') {
                    return 'Dark'
                }
                else {
                    return 'Light'
                }
            }
            catch {
                Write-Warning "Could not determine macOS theme: $_"
                return 'Light'  # macOS defaults to light
            }
        }
        default {
            return 'Dark'
        }
    }
}

Export-ModuleMember -Function Get-CurrentTheme

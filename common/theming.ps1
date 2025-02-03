function Get-CurrentTheme {
  if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
    $os = 'Windows'
  } elseif ($IsLinux) {
    $os = 'Linux'
  } else {
    $os = 'MacOS'
  }

  switch ($os) {
    'Windows' {
      $themeValue = (Get-ItemProperty -Path 'HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize' -Name AppsUseLightTheme).AppsUseLightTheme
      if ($themeValue -gt 0) {
        return 'Light'
      } else {
        return 'Dark'
      }
    }
    'Linux' {
      $gtkTheme = & gsettings get org.gnome.desktop.interface gtk-theme 2>$null
      if ($gtkTheme -match 'dark') {
        return 'Dark'
      }
      else {
        return 'Light'
      }
    }
    'MacOS' {
      $preferences = defaults read -g AppleInterfaceStyle 2>$null
      if ($preferences -eq 'Dark') {
        return 'Dark'
      }
      else {
        return 'Light'
      }
    }
    default {
      return 'Dark'
    }
  }
}

Export-ModuleMember -Function Get-CurrentTheme
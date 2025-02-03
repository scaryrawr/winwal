function Get-CurrentTheme {
  $os = $IsWindows ? 'Windows' : ($IsLinux ? 'Linux' : 'MacOS')

  switch ($os) {
    'Windows' {
      return (Get-ItemProperty -Path 'HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize' -Name AppsUseLightTheme).AppsUseLightTheme -gt 0 ? 'Light' : 'Dark'
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
# WinWAL

A wrapper around [pywal](https://github.com/dylanaraps/pywal) for Windows.

## Installing

Clone the repository and update your powershell profile to have:

```powershell
Import-Module .\path\to\winwal.psm1
```

## Using

To update wal cache using the current wallpaper:
```powershell
Update-WalTheme
```

To update wal cache, Windows-Terminal Color Scheme, and set the desktop wallpaper:
```powershell
Update-WalTheme -Image .\path\to\new\background.jpg
```

To update Windows Terminal Color Scheme with existing wal cache:
```powershell
Update-WalTerminal
```

To update pwsh prompt (not [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/)):
```powershell
Update-WalCommandPrompt
```

Notes: `Update-WalCommandPrompt` will download [ColorTool](https://devblogs.microsoft.com/commandline/introducing-the-windows-console-colortool/) and use it to set the new default color schemes.

## Dependencies

Use [`pip`](https://pypi.org/project/pip/) to install:
- [pywal](https://github.com/dylanaraps/pywal)
- [colorthief](https://github.com/fengsp/color-thief-py)
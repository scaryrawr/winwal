# winwal

A wrapper around [pywal](https://github.com/dylanaraps/pywal) for Windows.

![Cycle Image Demo](./assets/demo.gif)
Art from [wallpaperhub](https://wallpaperhub.app/)

## Dependencies

Only 1 backend is needed to get started, but each backend will provide slightly different color schemes.

pywal supports more backends, but I have not tried figuring them all out on Windows yet.

Use [`pip`](https://pypi.org/project/pip/) to install:
- [pywal](https://github.com/dylanaraps/pywal)
- [colorthief](https://github.com/fengsp/color-thief-py)
- [colorz](https://github.com/metakirby5/colorz)
- [haishoku](https://github.com/LanceGin/haishoku)

```powershell
winget install Python.Python
pip install pywal
pip install colorthief
pip install colorz
pip install haishoku
```

## Installing

Clone the repository and update your powershell profile to have:

```powershell
Import-Module .\path\to\winwal.psm1
```

To open your profile with code:
```powershell
code $profile
```

## Using

To update wal cache Windows Terminal Color Scheme using the current wallpaper:
```powershell
Update-WalTheme
```

To update wal cache, Windows Terminal Color Scheme, and set the desktop wallpaper:
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

## Keep WSL in sync

I have pywal installed in WSL and create a symbolic link in WSL so I only have to update in Windows and it gets mirrored in WSL:

```sh
ln -s /mnt/c/Users/username/.cache/wal ~/.cache/wal
```

There's also instructions in [pywal](https://github.com/dylanaraps/pywal) on setting up your dot files that need to be followed (look for .bashrc instructions).

## VS Code Plugins Used
- [wal-theme](https://marketplace.visualstudio.com/items?itemName=dlasagno.wal-theme)
- [GlassIt-VSC](https://marketplace.visualstudio.com/items?itemName=s-nlf-fh.glassit)
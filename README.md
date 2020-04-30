# terminal-profile

## 1.0 About

This is a decorative yet minimalistic scheme bundle for [Windows Terminal]( https://github.com/microsoft/terminal ). Enclosed are color schemes, profile icons, and background images.

## 2.0 Install

### Installers ( wip )

* ```CD``` into wherever this repo is on the computer.
* From within ```terminal-profile```'s root directory, run either: [.\install.ps1](install.ps1) or [.\install.bat](install.bat).

```diff
IMPORTANT:
- Installer scripts will abort if ran. 
- They have not been live tested yet, and they are just place holder algorithms. 
- I will test it later when I have finalized the default customizations.
```

### Manual Install ( safe )

* [Install multimedia graphics](RoamingState/README.md)
* [Copy my configuration settings](LocalState/README.md)
    * Redundant: [Install color schemes](color-schemes/README.md)

## 3.0 Notes

### CLI Arguments ( PS or CMD )

| Execution Alias | Description |
| --- | --- |
| ```wt -d . ``` | Opens terminal at home directory |
| ```wt -d . ; new-tab -d C:\ pwsh.exe``` | Opens the Terminal with two tabs |
| ```wt -p "Windows PowerShell" -d . ; split-pane -V wsl.exe``` | Opens the Terminal with two panes, split vertically. |

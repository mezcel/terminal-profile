# terminal-profile

## 1.0 About

* A minimalistic scheme bundle for [Windows Terminal]( https://github.com/microsoft/terminal ).
* Enclosed are: 
    * json color schemes, icons, images, and a config file.
    * I also made an [installer]( install.ps1 ) and a [theme switcher]( scheme_selector.ps1 ).

[screenshots]( https://gist.github.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175#file-0-readme-md )

[![git.png]( https://gist.githubusercontent.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175/raw/74616d7e309bebb362fbc919d9a91f1ac87ad604/git.png )]( https://gist.github.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175#file-0-readme-md )

## 2.0 Install

### Installer ( scripts )

* Execute, either [install.ps1](install.ps1) or [install.bat](install.bat), from this repo's root directory.

    ```diff
    IMPORTANT:
    - The installer will close all Windows Terminal instances if any are opened.
    - Processes actively running in Windows Terminal, inculding the installer script, will terminate.
    - Run installer using Win10's native Powershell or Command Prompt clients.
    ```

* **Theme selector** script [scheme_selector.ps1](scheme_selector.ps1)
    * The settings.json file must be cleared of all comments
        * Powershell's json parser does not like comments.
    * Script assumes the user has: ```$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\backgrounds\```

### Manual Install ( drag-n-drop )

* [Install multimedia graphics](RoamingState/README.md)
* [Copy my configuration settings](LocalState/README.md)
    * Redundant: [drag and drop color schemes](color-schemes/README.md)

## 3.0 Notes

### CLI Arguments ( PS or CMD )

| Execution Alias | Description |
| --- | --- |
| ```wt -d . ``` | Opens terminal at home directory |
| ```wt -d . ; new-tab -d C:\ pwsh.exe``` | Opens the Terminal with two tabs |
| ```wt -p "Windows PowerShell" -d . ; split-pane -V wsl.exe``` | Opens the Terminal with two panes, split vertically. |

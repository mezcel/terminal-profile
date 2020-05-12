# terminal-profile

## 1.0 About

* A minimalistic scheme bundle for [Windows Terminal]( https://github.com/microsoft/terminal ).
* Enclosed are: 
    * Theming resources
    * Automation shell scripts

[screenshots]( https://gist.github.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175#file-0-readme-md )

[![git.png]( https://gist.githubusercontent.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175/raw/74616d7e309bebb362fbc919d9a91f1ac87ad604/git.png )]( https://gist.github.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175#file-0-readme-md )
<sup>gist: https://gist.github.com/b4ce7f783597fb0ee97dfe66a9239175.git<sup> <sup>multimedia-repo ( WIP )</sup>

## 2.0 Install

### 2.1 Installer ( shell scripts )

* **Execute**, either **[install.ps1](install.ps1)** or [install.bat](install.bat), from this repo's root directory, from ```Powershell``` or ```Command Prompt```.

    * The ```.bat``` script works out of the box on anyone's Win10 machine
    * The ```.ps1``` requires user permissions enabled within Powershell.
        ```ps1
        ## option 1: set permission in script x86 x64
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

        ## option 2: set permissions through x64 developer settings
        Start-Process "ms-settings:developers"
        ```

### 2.2 Manual Install ( drag-n-drop )

* [Drag-n-drop images](RoamingState/README.md)
* [Copy settings file](LocalState/README.md)
* [Copy color schemes](color-schemes/README.md) ( *Redundant* )

## 3.0 Customize

### 3.1 Wizard ( Powershell script )

* **Theme selector** script **[scheme_selector.ps1](scheme_selector.ps1)**

    ```ps1
    <# Launch script #>

    .\scheme_selector.ps1                   ## Normal operation

    <# Launch script with flags #>

    .\scheme_selector.ps1 --help            ## Help instructions
    .\scheme_selector.ps1 --reset           ## Restores profiles back to my defaults
    .\scheme_selector.ps1 --del-backups     ## Cleans out all temporary backups"
    ```

### 3.2 Manually Edit Settings

> Find the dropdown menu in Windows Terminal and click ```Settings```. A text editor will pop up with the ```settings.json``` file loaded. Manually type in whatever features you know your system supports.

## 4.0 WT Notes

### CLI Arguments ( PS or CMD )

| Execution Alias | Description |
| --- | --- |
| ```wt -d . ``` | Opens terminal at home directory |
| ```wt -d . ; new-tab -d C:\ pwsh.exe``` | Opens the Terminal with two tabs |
| ```wt -p "Windows PowerShell" -d . ; split-pane -V wsl.exe``` | Opens the Terminal with two panes, split vertically. |

# terminal-profile

## 1.0 About

* A minimalistic scheme bundle for [Windows Terminal]( https://github.com/microsoft/terminal ).
* Enclosed are: 
    * json color schemes, icons, images, and a config file.
    * I also made an [installer]( #installer--shell-scripts- ) and a [theme switcher]( #31-wizard--powershell-script- ).

[screenshots]( https://gist.github.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175#file-0-readme-md )

[![git.png]( https://gist.githubusercontent.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175/raw/74616d7e309bebb362fbc919d9a91f1ac87ad604/git.png )]( https://gist.github.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175#file-0-readme-md )
gist: ```https://gist.github.com/b4ce7f783597fb0ee97dfe66a9239175.git```

## 2.0 Install

### 2.1 Installer ( shell scripts )

* **Execute**, either <u>**[install.ps1](install.ps1)**</u> or <u>**[install.bat](install.bat)**</u>, from this repo's root directory, via Command Prompt or Powershell.

    * ```.bat``` script works out of the box on anyone's Win10 machine
    * ```.ps1``` requires Powershell permissions.
        ```ps1
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
        ```

### 2.2 Manual Install ( drag-n-drop )

* [Install multimedia graphics](RoamingState/README.md)
* [Copy my configuration settings](LocalState/README.md)
* [Drag and drop color schemes](color-schemes/README.md) ( *Redundant* )

## 3.0 Customize

### 3.1 Wizard ( Powershell script )

* **Theme selector** script <u>**[scheme_selector.ps1](scheme_selector.ps1)**</u>
    * The settings.json file must be cleared of all comments
        * Powershell's json parser does not like comments.

    ```ps1
    ## Launch
    .\scheme_selector.ps1                   ## Normal operation

    ## Launch with Flags:
    .\scheme_selector.ps1 --help            ## Help instructions
    .\scheme_selector.ps1 --reset           ## Restores profiles back to my defaults
    .\scheme_selector.ps1 --del-backups     ## Cleans out all temporary backups"
    ```

### 3.2 Manually Edit Settings

> Find the dropdown in Windows Terminal and click setting. Type in whatever features you know your system supports.

## 4.0 Notes

### CLI Arguments ( PS or CMD )

| Execution Alias | Description |
| --- | --- |
| ```wt -d . ``` | Opens terminal at home directory |
| ```wt -d . ; new-tab -d C:\ pwsh.exe``` | Opens the Terminal with two tabs |
| ```wt -p "Windows PowerShell" -d . ; split-pane -V wsl.exe``` | Opens the Terminal with two panes, split vertically. |

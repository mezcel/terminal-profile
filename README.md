# terminal-profile

## 1.0 About

* A minimalistic scheme bundle for [Windows Terminal]( https://github.com/microsoft/terminal ).
* Enclosed are: color schemes, icons, images, config file, and <u>**[installer]( install.ps1 )**</u>.

[screenshots]( https://gist.github.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175#file-0-readme-md )

[![git.png]( https://gist.githubusercontent.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175/raw/74616d7e309bebb362fbc919d9a91f1ac87ad604/git.png )]( https://gist.github.com/mezcel/b4ce7f783597fb0ee97dfe66a9239175#file-0-readme-md )

## 2.0 Install

### Installers ( scripts )

* ```CD``` into wherever this repo is on the computer.
* From within ```terminal-profile```'s root directory, run either: [.\install.ps1](install.ps1) or [.\install.bat](install.bat).

    ```diff
    IMPORTANT:
    - DO NOT run scripts within Windows Terminal itself.
    - It will close itself and terminate the script. ( no harm, no foul )
    - Remove all comments (if any) from the settings.json file
    ```

* Theme selector script [scheme_selector.json](scheme_selector.json)
    * settings.json must be cleared of all comments
    * Optimized for the graphics included in this repo

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

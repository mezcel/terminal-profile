::::
:::: install.bat
::::
:::: source: https://github.com/mezcel/terminal-profile/install.bat
::::

@echo off

:::: Exit script
:::: This script is not tested yet
EXIT

:::: close Windows Terminal
:: taskkill /IM "WindowsTerminal.exe"

:::: time stamp
set dt=%DATE:~0,2%_%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%
set dt=%dt: =0%

:::: copy backgrounds and icons to RoamingState
:copyGraphics
    set sourceRS=".\RoamingState"
    set destinationRS="%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
    set backupRS=%destinationRS%-backup%dt%

    :::: Backup RoamingState
    IF EXIST %destinationRS% xcopy /s /i %destinationRS% "%backupRS%"

    xcopy /s /i %sourceRS% %destinationRS%

:::: copy settings.json to LocalState
:copySettings
    set sourceLS=".\LocalState\settings.json"
    set destinationLS="%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    set backupLS="%destinationLS%\-backup%dt%.txt"

    :::: Backup LocalState
    IF EXIST %sourceLS% copy %sourceLS% "%backupLS%"

    copy %sourceLS% "%destinationLS%\"

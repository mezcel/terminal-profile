::::
:::: install.bat
::::
:::: source: https://github.com/mezcel/terminal-profile/install.bat
::::

@ECHO off

ECHO :::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO :: terminal-profile
ECHO :: by:      mezcel
ECHO :: git:     https://github.com/mezcel/terminal-profile
ECHO :: About:   Import customized profile schemes
ECHO :::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO.

:::: time stamp
:getTimeStamp
    set dt=%DATE:~0,2%_%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%
    set dt=%dt: =0%

:::: close Windows Terminal
ECHO :: Step 1. Close any open Windows Terminal sessions.
:stopWT
    ::taskkill /IM "WindowsTerminal.exe"
    tasklist /fi "imagename eq WindowsTerminal.exe" |find ":" > nul
    if errorlevel 1 taskkill /f /im "WindowsTerminal.exe"
    ECHO :: done.
    ECHO.

:::: copy backgrounds and icons to RoamingState
ECHO :: Step 2. Copy and backup the RoamingState directory.
:copyGraphics
    set sourceRS=".\RoamingState"
    set destinationRS="%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
    set backupRS=%destinationRS%-backup%dt%

    :::: Backup RoamingState
    ECHO :: Backup
    IF EXIST %destinationRS% xcopy /s /i %destinationRS% "%backupRS%" /Y /Q

    ECHO :: Copy
    xcopy /s /i %sourceRS% %destinationRS% /Y /Q
    ECHO :: done.
    ECHO.

:::: copy settings.json to LocalState
ECHO :: Step 3. Copy and backup the settings.json file.
:copySettings
    set sourceLS=".\LocalState\settings.json"
    set destinationLS="%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    set backupLS="%destinationLS%\settings-backup%dt%.json"

    :::: Backup LocalState
    ECHO :: Backup
    IF EXIST %sourceLS% copy %sourceLS% "%backupLS%"

    ECHO :: Copy
    copy %sourceLS% "%destinationLS%\"
    ECHO :: done.

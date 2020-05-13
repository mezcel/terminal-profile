::::
:::: install.bat
::::
:::: source: https://github.com/mezcel/terminal-profile/install.bat
::::

@ECHO off

:setLocalPathVars
    :: Local Path Vars
    set thisScriptName=%0
    set thisScriptParentDir=%~dp0

:greetings
    ECHO :::::::::::::::::::::::::::::::::::::::::::::::::::::::
    ECHO :: terminal-profile
    ECHO ::
    ECHO :: script:  %thisScriptName%
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
    if errorlevel 1 (
        ECHO.
        ECHO Windows Terminal is running.
        ECHO    Launch this script again from a stand alone Command Prompt.
        ECHO    It is generally a good practice not make changes to an application while it is running.
        ECHO    This script is going to terminate all instances of Windows Terminal. ( just for redundant safety )
        ECHO    Finish whatever is going on in any other tabs or WT sessions before continuing.
        ECHO    Execute intall.bat again in any other Command Prompt terminal.
        ECHO.

        set /p pausePrompt="Press ENTER to Launch an new instance of Command Prompt and close Windows Terminal."
        start cmd

        taskkill /f /im "WindowsTerminal.exe" )

    ECHO :: done.
    ECHO.

:::: copy backgrounds and icons to RoamingState
ECHO :: Step 2. Copy and backup the RoamingState directory.
:copyGraphics
    set sourceRS="%thisScriptParentDir%RoamingState"
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
    set sourceLS="%thisScriptParentDir%LocalState\settings.json"
    set destinationLS="%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    set backupLS="%destinationLS%\settings-backup%dt%.json"

    :::: Backup LocalState
    ECHO :: Backup
    IF EXIST %sourceLS% copy %sourceLS% "%backupLS%"

    ECHO :: Copy
    copy %sourceLS% "%destinationLS%\"
    ECHO :: done.

:: Confirmation display
ECHO :: Check: %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe
ECHO ::      \RemoteState and \LocalState
ECHO.

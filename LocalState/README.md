# LocalState settings

## Enclosed Demo file

* Enclosed is a copy of my Windows Terminal setup using the configurations provided in this repo.
* It is preconfigured as if all resources are installed.

## Edit file

### Manually change Windows Terminal's settings

1. Open Windows Terminal
2. Click on the down arrow in the title bar (just to the right of the plus symbol)
3. choose “Settings.”

### File path

```bat
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

---

## Note:

### GUID

> Each terminal profile is indexed with a GUID. This should be unique for each user. They are usually generated when Windows Terminal is installed, but if you need to make a fresh one, you can.

#### Generate a GUID in Powershell

```ps1
## windows powershell and type
[guid]::NewGuid()
```

#### Example:

```json
"profiles":  {
    "list":  [
        {
            "guid": "{ 680507ee-fd3b-467e-a55b-1bc95b40a025 }",
            "name": "My Terminal Profile Name"
        }
    ]
}
```

### VS Developer Mode for Powershell VsDevShell

> The ```Enter-VsDevShell VsDevShell``` number is different on every VS installation.

#### Find your VsDevShell number:

1. Go to your ```C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2019\Visual Studio Tools``` directory.
2. View the Properties on the Developer PowerShell for VS 2019 shortcut.
    * Read the existing ```target path``` string. 
3. Use that path as the ```{ "commanline": "" }``` json object element attribute value.

#### Example:

```json
"profiles":  {
    "list":  [
        {
            "name":  "Developer PowerShell for VS 2019",
            "commandline":  "powershell.exe -noe -c \"\u0026{Import-Module \"\"\"C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/Common7/Tools/Microsoft.VisualStudio.DevShell.dll\"\"\"; Enter-VsDevShell d6d20eb5}\""
        }
    ]
}
```
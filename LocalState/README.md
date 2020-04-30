# LocalState settings

## Demo file

* Enclosed is a copy of my Windows Terminal setup using the configurations provided in this repo.
* It is preconfigured as if all resources are installed.

## Edit file

Manually change Windows Terminal's settings

1. Open Windows Terminal
2. Click on the down arrow in the title bar (just to the right of the plus symbol)
3. choose “Settings.”

## File path

```bat
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

---

## Note:

Each terminal profile is indexed with a GUID. This should be unique for each user. They are usually generated when Windows Terminal is installed, but if you need to make a fresh one, you can.

### Generate a GUID in Powershell

```ps1
## windows powershell and type
[guid]::NewGuid()
```
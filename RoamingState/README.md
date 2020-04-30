# RoamingState Multimedia

## Instructions

Store local images in Window Terminal's ```RoamingState``` directory.

RoamingState directory path

```bat
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState
```
* Make sub-directories to better organized your multimedia
* this repo hosts a ```backgrounds``` image dir and a ```icons``` image dir.

* Apply images within a profile:

Example:

```json
"profiles": {
    "list": [
        {
            "hidden"                 : false,
            "name"                   : "Debian",
            "source"                 : "Windows.Terminal.Wsl",
            "icon"                   : "ms-appdata:///roaming/icons/<myIcon>.ico",
            "backgroundImage"        : "ms-appdata:///roaming/backgrounds/<myImage.png>"
        }
    ]
}
```
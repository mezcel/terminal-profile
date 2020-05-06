# Color Schemes

## Instructions

Manually copy the ```.json``` text and paste it into Terminal's ```settings.json``` file within the ```schemes``` array. Then use the scheme element name in a CLI profile.

* ```settings.json``` file path

    ```bat
    %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
    ```

* Add Custom Theme

    ```json
    "schemes": [
        {
            "name"          : "Ubuntu",
            "black"         : "#2e3436",
            "red"           : "#cc0000",
            "green"         : "#4e9a06",
            "yellow"        : "#c4a000",
            "blue"          : "#3465a4",
            "purple"        : "#75507b",
            "cyan"          : "#06989a",
            "white"         : "#d3d7cf",
            "brightBlack"   : "#555753",
            "brightRed"     : "#ef2929",
            "brightGreen"   : "#8ae234",
            "brightYellow"  : "#fce94f",
            "brightBlue"    : "#729fcf",
            "brightPurple"  : "#ad7fa8",
            "brightCyan"    : "#34e2e2",
            "brightWhite"   : "#eeeeec",
            "background"    : "#300a24",
            "foreground"    : "#eeeeec"
        }
    ]
    ```

* Apply Theme

    ```json
    "profiles": {
        "list": [
            {
                "hidden"      : false,
                "name"        : "Debian",
                "source"      : "Windows.Terminal.Wsl",
                "colorScheme" : "Ubuntu",
            },
        ]
    }  
    ```

## Themes:

### My Themes

My custom themes optimized for Vim's C syntax, folds, and highlighting, coloring defaults.

I also named them after ( Games Workshop / Citadel ) paint colors

* [Lucius Lilac Dark]( lucius-lilac-dark.json ) - A forked modification of [Dracula]( https://draculatheme.com/windows-terminal )
* [Apothecary White Light]( apothecary-white-light.json )
* [Nocturne Green Dark]( nocturne-green-dark.json )
* [Soulstone Blue](soulstone-blue.json)
* [Nord - Vim]( nord-vim.json ) - Just [Nord]( https://compiledexperience.com/blog/posts/windows-terminal-nord ), touched up a bit

### Community themes

* [Ubuntu]( https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/terminal/Ubuntu.terminal )
* [Dracula]( https://draculatheme.com/windows-terminal )
* [Nord]( https://compiledexperience.com/blog/posts/windows-terminal-nord )
* [VS Code]( https://github.com/adstep/vscode-windows-terminal-theme )
* [Violet Light]( https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/windowsterminal/Violet%20Light.json )
    * this is really Sepia or Solarized Light
* [iTerm2-Color-Schemes]( https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master/windowsterminal )
* [terminalsplash]( https://terminalsplash.com/ )
* [ColorTool]( https://github.com/microsoft/terminal/releases/tag/1904.29002 )

#### General Colors for Vim

    ```json
    {
        "name"          : "Nocturne Green Dark",
        "red"           : "#808851", // Numbers
        "blue"          : "#6d5922", // Comments
        "purple"        : "#7fa009", // Include
        "white"         : "#647d75", // Highlight
        "brightGreen"   : "#4d7748", // PS1
        "brightBlue"    : "#7e4c12", // Dir
        "background"    : "#0f1610", // background
        "foreground"    : "#637d75", // general text
        "cursorColor"   : "#3eb944"  // cursor
    }
    ```
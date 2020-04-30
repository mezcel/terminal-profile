##
## install.ps1
##
## source: https://github.com/mezcel/terminal-profile/install.ps1
##

## Exit App as soon as it runs
## This script is not tested yet
Exit

## Copy backgrounds and icons to RoamingState
function copyGraphics() {
    $source = 'RoamingState'
    $destination = '%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState'

    if ( Test-Path $destination ) {

        ## Backup RoamingState
        $time = (Get-Date).ToString("yyyy_MM_dd_h_m_s")
        Copy-Item $destination -Recurse -Destination $destination"(backup-"$time")"
        
        ## Copy
        Copy-Item $source\* -Recurse -Destination $destination
    }
}

## Copy settings.json to LocalState
function copySettings() {
    $source = 'LocalState\settings.json'
    $destination = '%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState'

    if ( Test-Path $destination ) {
        
        ## Backup settings.json
        $time = (Get-Date).ToString("yyyy_MM_dd_h_m_s")
        Copy-Item $destination\settings.json -Destination $destination\settings"(backup-"$time").json"

        ## Copy
        Copy-Item $source -Destination $destination\"settings.json"
    }
}

function main() {

    # Stop-Process -Name 'WindowsTerminal'

    copyGraphics
    copySettings

}

## Run

main
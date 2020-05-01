##
## install.ps1
##
## source: https://github.com/mezcel/terminal-profile/install.ps1
##

## Exit App as soon as it runs
## This script is not tested yet
#Exit

## Close any running Windows Terminal Sessions
function closeWT() {
    $wtProcess = Get-Process 'WindowsTerminal' -ErrorAction SilentlyContinue

    if ( $wtProcess ) {
        Write-Host "Closeing Windows Termainl" -ForegroundColor Magenta
        ## try to close gracefully first
        $wtProcess.CloseMainWindow()

        ## Redundant retry
        #Start-Sleep 5
        if ( !$wtProcess.HasExited ) {
            $wtProcess | Stop-Process -Force
        }
    }
    Remove-Variable wtProcess
    Write-Host "done." -ForegroundColor Green
}

## Copy backgrounds and icons to RoamingState
function copyGraphics() {
    $source      = "RoamingState"
    $destination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"

    if ( Test-Path $destination ) {

        ## Backup RoamingState
        $time = (Get-Date).ToString("yyyy_MM_dd_h_m_s")
        Copy-Item $destination -Destination $destination"(backup-"$time")" -Recurse -Force
        Start-Sleep 1
        
        ## Copy
        Copy-Item $source\* -Destination $destination -Recurse -Force
    }

    Write-Host "done." -ForegroundColor Green
}

## Copy settings.json to LocalState
function copySettings() {
    $source      = "LocalState\settings.json"
    $destination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

    if ( Test-Path $destination ) {
        ## Backup settings.json
        $time = (Get-Date).ToString("yyyy_MM_dd_h_m_s")
        Copy-Item $destination\settings.json -Destination $destination\settings"(backup-"$time").json" -Force
        Start-Sleep 1

        ## Copy
        Copy-Item $source -Destination $destination\"settings.json" -Force
    }
    Write-Host "done." -ForegroundColor Green
}

## Main fun
function main() {
    Write-Host ""
    Write-Host "####################################################### "-BackgroundColor White -ForegroundColor Black
    Write-Host "## terminal-profile                                     "-BackgroundColor White -ForegroundColor Black
    Write-Host "## by:      mezcel                                      "-BackgroundColor White -ForegroundColor Black
    Write-Host "## git:     https://github.com/mezcel/terminal-profile  "-BackgroundColor White -ForegroundColor Black
    Write-Host "## About:   Import customized profile schemes           "-BackgroundColor White -ForegroundColor Black
    Write-Host "####################################################### "-BackgroundColor White -ForegroundColor Black
    Write-Host ""

    Write-Host "Step 1. Close any open Windows Terminal sessions." -ForegroundColor Yellow
    #Stop-Process -Name 'WindowsTerminal'
    closeWT

    Write-Host ""
    Write-Host "Step 2. Copy and backup the RoamingState directory." -ForegroundColor Yellow
    copyGraphics

    Write-Host ""
    Write-Host "Step 3. Copy and backup the settings.json file." -ForegroundColor Yellow
    copySettings
}

## Run
main

Write-Host ""
Write-Host "done." -ForegroundColor Green
Write-Host "Check: $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe" -ForegroundColor Cyan
Write-Host "    \RemoteState and \LocalState" -ForegroundColor Cyan
Write-Host ""
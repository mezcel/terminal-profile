##
## scheme_selector.ps1
##
## Theme selector for Windows Terminal
## https://github.com/mezcel/terminal-profile.git
##

##############################################
## Make Arrays of avilable setting options
##############################################

function setSchemeArray() {
	$outputArray = @()

	## List of Windows Terminal's factory default color schemes
	$defaultSchemesArr = @( "Campbell","Campbell Powershell", "Vintage", "One Half Dark", "One Half Light", "Solarized Dark", "Solarized Light", "Tango Dark", "Tango Light" )
	$outputArray += ( $defaultSchemesArr )

	$settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
	$json = (Get-Content $settingsLocal -Raw) | ConvertFrom-Json

	for( $k = 0; $k -lt $json.schemes.name.length; $k++ ) {
		$string = $json.schemes[$k].name
		$outputArray += ( $string.ToString() ) 
	}
	
	return $outputArray
}

function setImageArray() {
	$outputArray = @()

	## list of available .png images within the "backgrounds folder"
    $dirRoamingState = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\backgrounds\*.png"
    
	$files = @( Get-ChildItem $dirRoamingState -Name )
	foreach ( $file in $files ) {
		$outputArray += ( $file.ToString() ) 
	}

	return $outputArray
}

function setProfileNamesArray() {
	$outputArray = @()

	## List of existing temrinal profiles in settings.json
	$settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
	$json = (Get-Content $settingsLocal -Raw) | ConvertFrom-Json

	for( $k = 0; $k -lt $json.profiles.list.name.length; $k++ ) {
		$string = $json.profiles.list[$k].name
		$outputArray += ( $string.ToString() ) 
	}
	
	return $outputArray
}

function setAlignmentArray() {
    $outputArray = @()
    $outputArray = @( "center", "top", "bottom", "left", "right", "topRight", "topLeft",  "bottomRight", "bottomLeft" )
    return $outputArray
}

function setStretchArray() {
    $outputArray = @()
    $outputArray = @( "none", "fill", "uniform", "uniformToFill" )
    return $outputArray
}

##############################################
## Display Arrays Options as a Numbered Menu
##############################################

function displayList( [string[]] $inputArray, [int] $minColWidth, [int] $noCols ) {

	for( $i = 0; $i -lt $inputArray.length; $i++ ) {
		$totalCount = $i
		$newLine = $i % $noCols
		
		$tabChar = ""
		$string = $inputArray[$i].ToString()
		$charCount = ($string.ToCharArray() | Where-Object {$_} | Measure-Object).Count

		$colDiff = $minColWidth - $charCount
		for( $j = 0; $j -le $colDiff; $j++ ) {
			$tabChar = $tabChar + " "
		}

		if ( $newLine -eq 0 ) { 
			Write-Host ""
		}
		
		if ($totalCount -lt 10) {
			$totalCount = " " + $totalCount
		}

		Write-Host -NoNewline "$totalCount. "$string$tabChar
	}
}

##############################################
## Write selections to Json ( settings.json )
##############################################

function backupSettings() {
    Write-Host ""
    $destination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    Write-Host "Backup Copying:`n`t$destination\settings.json" -ForegroundColor Cyan

    if ( Test-Path $destination ) {
        ## Backup settings.json
        $time = (Get-Date).ToString("yyyy_MM_dd_h_m_s")
        Copy-Item $destination\settings.json -Destination $destination\settings"(backup-"$time").json" -Force
        Start-Sleep 1
    }

    Write-Host "Done.`n`tBackup Copied:`n`t$destination\settings.json" -ForegroundColor Green
}

function writeProfile( [string]$MyName, [string]$MyColorscheme, [string]$MyBackgroundImage, 
    [string]$MyBackgroundImageAlignment, [string]$MyBackgroundImageStretchMode, [double]$MyBackgroundImageOpacity ) {

    Write-Host ""
    $settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Write-Host "Editing:`n`t$settingsLocal" -ForegroundColor Cyan
	$mySettings = Get-Content "$settingsLocal" -raw | ConvertFrom-Json

	$mySettings.profiles.list | % {
			if( $_.name -eq $MyName ) {
				$_.colorscheme = $MyColorscheme
				$_.backgroundImage = "ms-appdata:///roaming/backgrounds/$MyBackgroundImage"
				$_.backgroundImageAlignment = $MyBackgroundImageAlignment
				$_.backgroundImageStretchMode = $MyBackgroundImageStretchMode
				$_.backgroundImageOpacity = $MyBackgroundImageOpacity
			}
		}
		
    $mySettings | ConvertTo-Json -depth 32 | set-content "$settingsLocal"
    Write-Host "Done.`n`tEdited:`n`t$settingsLocal" -ForegroundColor Green    
}

function main() {

    $profileNames = @(setProfileNamesArray)
    $colorSchemes= @(setSchemeArray)
    $backgroundImage = @(setImageArray)
    $imageAlign = @(setAlignmentArray)
    $imageStretch = @(setStretchArray)

    ## Profile
    Write-Host "Select an existing terminal profile to edit" -ForegroundColor Cyan
    Write-Host "Existing Termainl Profiles:" -ForegroundColor Yellow
    $colWidth = 32
    $colNo = 3
    displayList $profileNames $colWidth $colNo
    Write-Host ""
    Write-Host ""
    $arrLen = $profileNames.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    $menuNumber = Read-Host "Enter number"
    $name = $profileNames[$menuNumber]
    Write-Host "You selected: "$name

    ## Color Scheme
    Write-Host ""
    Write-Host "Select an existing color scheme to apply to profile" -ForegroundColor Cyan
    Write-Host "Installed Color Schemes:" -ForegroundColor Yellow
    $colWidth = 24
    $colNo = 4
    displayList $colorSchemes $colWidth $colNo
    Write-Host ""
    Write-Host ""
    $arrLen = $colorSchemes.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    Write-Host "`tNote: Most color schemes look bad on Powershell."
    $menuNumber = Read-Host "Enter number"
    $color = $colorSchemes[$menuNumber]
    Write-Host "You selected: "$color

    ## Background Picture
    Write-Host ""
    Write-Host "Select an existing picture to apply to scheme" -ForegroundColor Cyan
    Write-Host "Available Background Images:" -ForegroundColor Yellow
    $colWidth = 24
    $colNo = 4
    displayList $backgroundImage $colWidth $colNo
    Write-Host ""
    Write-Host ""
    $arrLen = $backgroundImage.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    $menuNumber = Read-Host "Enter number"
    $pic = $backgroundImage[$menuNumber]
    Write-Host "You selected: "$pic

    ## Picture Alignment
    Write-Host ""
    Write-Host "Select an alignment to apply to background picture" -ForegroundColor Cyan
    Write-Host "Available Alignment Options:" -ForegroundColor Yellow
    $colWidth = 12
    $colNo = 3
    displayList $imageAlign $colWidth $colNo
    Write-Host ""
    Write-Host ""
    $arrLen = $imageAlign.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    $menuNumber = Read-Host "Enter number"
    $align = $imageAlign[$menuNumber]
    Write-Host "You selected: "$align

    ## Picture Stretch
    Write-Host ""
    Write-Host "Select a stretch to apply to background picture" -ForegroundColor Cyan
    Write-Host "Available Stretch Options:" -ForegroundColor Yellow
    $colWidth = 12
    $colNo = 2
    displayList $imageStretch $colWidth $colNo
    Write-Host ""
    Write-Host ""
    $arrLen = $imageStretch.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    $menuNumber = Read-Host "Enter number"
    $stretch = $imageStretch[$menuNumber]
    Write-Host "You selected: "$stretch

    ## Picture Opacity/Transparency
    Write-Host ""
    Write-Host "Select the opacity alpha transparacy to apply to the background picture" -ForegroundColor Cyan
    Write-Host "Available Opacity Options:" -ForegroundColor Yellow
    Write-Host "Select a number between [ 0 - 1 ]`n`tAim arround ( 0.1 - 0.3 ) for a more discrete look.`n"
    $alpha = Read-Host "Enter number"
    Write-Host "You entered: "$alpha

    ## Selection Summary
    Write-Host ""
    Write-Host "Selection Summary:`n" -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tProfile Name`t`t: $name" -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tScheme Color`t`t: $color " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tBackground Picture`t: $pic " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tPicture Allignment`t: $align " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tPicture Stretch`t`t: $stretch " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tPicture Alpha`t`t: $alpha " -ForegroundColor Red -BackgroundColor Black
    Write-Host ""
    
    ## Confirmation Prompt
    $yn = ""
    While( ( $yn -ne "yes") -and ( $yn -ne "no" ) ) {
        ## Write files
        Write-Host "Procede? "
        $yn = "n"
        $yn = Read-Host "Enter: 'yes' or 'no' "

        if ( $yn -eq "yes" ) {
            backupSettings
            writeProfile $name $color $pic $align $stretch $alpha
            exit
        }

        if ( $yn -eq "no" ) {
            Write-Host "`nNo Changes were applied. Try again when you are ready.`n" -ForegroundColor Red
        }

        if ( ( $yn -ne "yes") -and ( $yn -ne "no" ) ) {
            Write-Host "`nTry again." -ForegroundColor Yellow
            Write-Host "`tYou entered: $yn`n" -ForegroundColor Yellow
        }

    }

    ## Edit settings.json in notepad
    # notepad $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
    ## Manage Backup files in windows explorer
    # explorer $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
    ## Manage Backup dirs in windows explorer
    # explorer $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe
}

#####################
## Run
#####################

Clear-Host

## Title header
Write-Host "###################################################################"
Write-Host "## Windows Terminal Theme Selection "
Write-Host "###################################################################"
Write-Host "##"
Write-Host "## About:"
Write-Host "##  This script will set up a profile theme with existing resources"
Write-Host "##"
Write-Host "## Note:"
Write-Host "##  settings.json must be clear of all comment"
Write-Host "##  comments will be interpreted as json file sytax errors"
Write-Host "##"
Write-Host "## Author:"
Write-Host "##  Mezcel"
Write-Host "##  https://github.com/mezcel/terminal-profile.git"
Write-Host "##"
Write-Host "###################################################################"
Write-Host "`nChanges to your system will not occur untill confirmation at the end.`n" -ForegroundColor Magenta

## Main

main


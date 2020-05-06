##
## scheme_selector.ps1
##
## Theme selector for Windows Terminal
## https://github.com/mezcel/terminal-profile.git
##

## Make Arrays

function setSchemeArray() {
	$outputArray = @()

	## List installed color schemes
	$defaultSchemesArr = @( "Campbell","Campbell Powershell", "Vintage", "One Half Dark", "One Half Light", "Solarized Dark", "Solarized Light", "Tango Dark", "Tango Light" )
	$outputArray += ( $defaultSchemesArr )

	$settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
	$settingsLocal = ".\settings.json"
	$json = (Get-Content $settingsLocal -Raw) | ConvertFrom-Json

	for( $k = 0; $k -lt $json.schemes.name.length; $k++ ) {
		$string = $json.schemes[$k].name
		$outputArray += ( $string.ToString() ) 
	}
	
	return $outputArray
}

function setImageArray() {
	$outputArray = @()

	## list of available .png images
	$dirRoamingState = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\backgrounds\*.png"
	$files = @( Get-ChildItem $dirRoamingState -Name )
	foreach ( $file in $files ) {
		$outputArray += ( $file.ToString() ) 
	}

	return $outputArray
}

function setProfileNamesArray() {
	$outputArray = @()

	## List of temrinal profiles

	$settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
	$settingsLocal = ".\settings.json"
	$json = (Get-Content $settingsLocal -Raw) | ConvertFrom-Json

	for( $k = 0; $k -lt $json.profiles.list.name.length; $k++ ) {
		$string = $json.profiles.list[$k].name
		$outputArray += ( $string.ToString() ) 
	}
	
	return $outputArray
}

function setAlignmentArray() {
    $outputArray = @()
    $outputArray = @( "top", "topRight", "topLeft", "bottom", "bottomRight", "bottomLeft", "right", "left", "center" )
    return $outputArray
}

function setStretchArray() {
    $outputArray = @()
    $outputArray = @( "fill", "none", "uniform", "uniformToFill" )
    return $outputArray
}

## Display Arrays Options

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

## Write selections to Json ( settings.json )

function copySettings() {
    Write-Host ""
    $destination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    Write-Host Copying: $destination\settings.json -ForegroundColor Cyan

    if ( Test-Path $destination ) {
        ## Backup settings.json
        $time = (Get-Date).ToString("yyyy_MM_dd_h_m_s")
        Copy-Item $destination\settings.json -Destination $destination\settings"(backup-"$time").json" -Force
        Start-Sleep 1
    }

    Write-Host "done." -ForegroundColor Green
    Write-Host "`tCopied: $destination\settings.json" -ForegroundColor Green
}

function writeProfile( [string]$MyName, [string]$MyColorscheme, [string]$MyBackgroundImage, [string]$MyBackgroundImageAlignment, [string]$MyBackgroundImageStretchMode, [double]$MyBackgroundImageOpacity ) {
    Write-Host ""

    $settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    
    Write-Host Editing: $settingsLocal -ForegroundColor Cyan
    #$settingsLocal =".\settings.json"
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
    
    Write-Host "done." -ForegroundColor Green
    Write-Host "`tWrote: $settingsLocal" -ForegroundColor Green    
}

function main() {

    $profileNames = @(setProfileNamesArray)
    $colorSchemes= @(setSchemeArray)
    $backgroundImage = @(setImageArray)
    $imageAlign = @(setAlignmentArray)
    $imageStretch = @(setStretchArray)

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
    $menuNumber = Read-Host "Enter number"
    $color = $colorSchemes[$menuNumber]
    Write-Host "You selected: "$color

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

    Write-Host ""
    Write-Host "Select a stretch to apply to background picture" -ForegroundColor Cyan
    Write-Host "Available Stretch Options:" -ForegroundColor Yellow
    Write-Host "Select a number between [ 0.0 - 1.0 ] "
    $alpha = Read-Host "Enter number"
    Write-Host "You entered: "$alpha

    Write-Host ""
    Write-Host "Selection Summary:"
    Write-Host "
        Profile Name        : $name 
        Scheme Color        : $color 
        Background Picture  : $pic 
        Picture Allignment  : $align 
        Picture Stretch     : $stretch 
        Picture Alpha       : $alpha
    "

    ## Write files
    Write-Host "Procede? "
    $yn = "n"
    $yn = Read-Host "Enter: 'yes' or 'no' "

    if ( $yn -eq "yes" ) {
        copySettings
        writeProfile $name $color $pic $align $stretch $alpha
    }

    ## Edit settings.json in notepad
    # notepad $settingsLocal
}

#####################
## Run
#####################

Clear-Host

Write-Host "###################################################################"
Write-Host "## Windows Terminal Theme Selection                              ##"
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
Write-Host ""

## Main

main


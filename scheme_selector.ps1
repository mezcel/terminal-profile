<#
    scheme_selector.ps1

    Theme selector for Windows Terminal
    https://github.com/mezcel/terminal-profile.git
#>

## External argument inputs
param( $inputArgs )

# Error message regarding comments in Json file
function knownParsingError() {
    ## Help for manually fixing the json file

    Write-Host "`nAn error occurred:" -ForegroundColor Red
    Write-Host "`t Read the error msg. It is likely because comments were detected in settings.json" -ForegroundColor Red
    Write-Host "`t Powershell's built-in Json parsing feature does this." -ForegroundColor Red
    Write-Host "`t Remove ALL comments in file and try again." -ForegroundColor Red
    Write-Host "`t This script will terminate after the following question.`n" -ForegroundColor Red

    $yn = Read-Host "Do you want to open and edit the settings.json file at this time? [ y / N ] "
    if ( $yn -eq "y" ) {
        $settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

        ## launch an available text editor
        if ( Get-Command code -ErrorAction 'SilentlyContinue' ) { 
            code $settingsLocal 
        } elseif ( [System.IO.File]::Exists( "C:\Program Files\Notepad++\notepad++.exe" ) ) {
            start notepad++ $settingsLocal 
        } else {
            notepad $settingsLocal
        }
    } 
    Write-Host ""
    Exit
}

##############################################
## Make Arrays of avilable setting options
##############################################


function setSchemeArray() {
	$outputArray = @()

	## List of Windows Terminal's factory default color schemes
	$defaultSchemesArr = @( "Campbell", "Campbell Powershell", "Vintage", "One Half Dark", "One Half Light", "Solarized Dark", "Solarized Light", "Tango Dark", "Tango Light" )
	$outputArray += ( $defaultSchemesArr )

    $settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

    try { 
        $json = (Get-Content $settingsLocal -Raw) | ConvertFrom-Json
    } catch { knownParsingError }

	for( $k = 0; $k -lt $json.schemes.name.length; $k++ ) {
		$string = $json.schemes[$k].name
		$outputArray += ( $string.ToString() ) 
	}
	
	return $outputArray
}

function setImageArray() {
	$outputArray = @( "none" )

    ## list of available .png images within the "backgrounds folder"
    $roamingDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
    
    if ( Test-Path -Path "$roamingDir\backgrounds" ) {
        $dirRoamingState = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\backgrounds\*"
    } else {
        $dirRoamingState = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\*"
    }
    
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

    try { 
        $json = (Get-Content $settingsLocal -Raw) | ConvertFrom-Json
    } catch { knownParsingError }

	for( $k = 0; $k -lt $json.profiles.list.name.length; $k++ ) {
		$string = $json.profiles.list[$k].name
		$outputArray += ( $string.ToString() ) 
	}
	
	return $outputArray
}

function setAlignmentArray() {
    $outputArray = @( "center", "top", "bottom", "left", "right", "topRight", "topLeft",  "bottomRight", "bottomLeft" )
    return $outputArray
}

function setStretchArray() {
    $outputArray = @( "none", "fill", "uniform", "uniformToFill" )
    return $outputArray
}

##############################################
## Display Arrays Options as a Numbered Menu
##############################################

function displayList( [string[]] $inputArray, [int] $minColWidth, [int] $noCols ) {

	for( $i = 0; $i -lt $inputArray.length; $i++ ) {
		$totalCount = $i
		$newLine    = $i % $noCols
		
		$tabChar    = ""
		$string     = $inputArray[$i].ToString()
		$charCount  = ($string.ToCharArray() | Where-Object {$_} | Measure-Object).Count

		$colDiff    = $minColWidth - $charCount
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
    $destination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

    Write-Host "`nCopy and Backup: settings.json" -ForegroundColor Magenta
    Write-Host "`t$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\..." -ForegroundColor Magenta
    Write-Host "`t  LocalState\settings.json`n" -ForegroundColor Magenta
    Start-Sleep 1

    if ( Test-Path $destination ) {
        ## Backup settings.json
        $time = (Get-Date).ToString("yyyy_MM_dd_h_m_s")
        $backupFile = "settings($time).backup"
        Copy-Item "$destination\settings.json" -Destination "$destination\$backupFile" -Force
        Start-Sleep 1
    }

    Write-Host "Done.`nBackup and Copied: $backupFile" -ForegroundColor Green
    Write-Host "`t$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\..." -ForegroundColor Green
    Write-Host "`t  LocalState\$backupFile`n" -ForegroundColor Green
    Start-Sleep 1

}

function remBackupSettings() {

    Write-Host "Removing backup settings.json files ...`n" -ForegroundColor Yellow

    ## Remove backup settings files
    $destination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    Remove-Item $destination\*.backup
    Start-Sleep 3

    Write-Host "Done.`nBackup files were removed from:`n`t$destination`n" -ForegroundColor Green
    Start-Sleep 1

    <#
        ## Manually Edit settings.json in notepad
        notepad $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

        ## Manually Manage Backup files in windows explorer
        explorer $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState

        ## Manually Manage Backup dirs in windows explorer
        explorer $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe
    #>
}

function writeProfile( [string]$MyName, [string]$MyColorscheme, [string]$MyBackgroundImage, 
    [string]$MyBackgroundImageAlignment, [string]$MyBackgroundImageStretchMode, [double]$MyBackgroundImageOpacity ) {

    $settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    
    Write-Host "`nCommence Editing: settings.json" -ForegroundColor Magenta
    Write-Host "`t$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\..." -ForegroundColor Magenta
    Write-Host "`t  LocalState\settings.json`n" -ForegroundColor Magenta

    try { 
        $mySettings = Get-Content "$settingsLocal" -raw | ConvertFrom-Json
    } catch { knownParsingError }
    
    if ( $MyBackgroundImage -eq "none" ) {
        $pic = ""
    } else {
        $roamingDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
        if ( Test-Path -Path "$roamingDir\backgrounds" ) {
            $appPath = "ms-appdata:///roaming/backgrounds"
        } else {
            $appPath = "ms-appdata:///roaming"
        }
        $pic = "$appPath/$MyBackgroundImage"
    }

	$mySettings.profiles.list | % {
			if( $_.name -eq $MyName ) {
				$_.colorscheme                = $MyColorscheme
				$_.backgroundImage            = $pic
				$_.backgroundImageAlignment   = $MyBackgroundImageAlignment
				$_.backgroundImageStretchMode = $MyBackgroundImageStretchMode
				$_.backgroundImageOpacity     = $MyBackgroundImageOpacity
			}
		}
		
    $mySettings | ConvertTo-Json -depth 32 | set-content "$settingsLocal"
    
    Write-Host "Done.`nFinished Editing: settings.json" -ForegroundColor Green
    Write-Host "`t$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\..." -ForegroundColor Green
    Write-Host "`t  LocalState\settings.json`n" -ForegroundColor Green
    Start-Sleep 1
}

##############################################
## Preview Pre-Changes State ( settings.json )
##############################################

function showProfile( [string]$MyName ) {

    $settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

    try { 
        $mySettings = Get-Content "$settingsLocal" -raw | ConvertFrom-Json
    } catch { knownParsingError }

	$mySettings.profiles.list | % {
        if( $_.name -eq $MyName ) {                
            Write-Host ""
            Write-Host "Current Profile Setting:`n" -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tProfile Name`t`t: $MyName" -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tScheme Color`t`t:"$_.colorscheme.ToString() -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tBackground Picture`t:"$_.backgroundImage.ToString() -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tPicture Alignment`t:"$_.backgroundImageAlignment.ToString() -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tPicture Stretch`t`t:"$_.backgroundImageStretchMode.ToString() -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tPicture Alpha`t`t:"$_.backgroundImageOpacity.ToString() -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host ""
        }
    }
}

function previewChanges( [string]$name, [string]$color, [string]$pic, [string]$align, [string]$stretch, [double]$alpha ) {
    
    Write-Host ""
    Write-Host "Selection Summary:`n" -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tProfile Name`t`t: $name" -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tScheme Color`t`t: $color " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tBackground Picture`t: ( $pic ) " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tPicture Alignment`t: $align " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tPicture Stretch`t`t: $stretch " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tPicture Alpha`t`t: $alpha " -ForegroundColor Red -BackgroundColor Black
    Write-Host ""
}


###############################
## Make changes from selection
###############################

function isNumeric ( $Value ) {
    ## Return True if value is a number
    return $Value -match "^[\d\.]+$"
}

function correctNumRange( $inputNo, $min, $max, $defaultNo ) {

    if ( isNumeric $inputNo ) {
        if (( $inputNo -lt $min ) -and ( $inputNo -gt $max )) {
            Write-Host "`tYou entered ""$inputNo"", that value is not within ( $min to $max )." -ForegroundColor Red
            Write-Host "`tSet to default $defaultNo" -ForegroundColor Red
            $inputNo = $defaultNo
        }
    } else {
        Write-Host "`tYou entered ""$inputNo"", that value is not within ( $min to $max )." -ForegroundColor Red
        Write-Host "`tSet to default $defaultNo" -ForegroundColor Red
        $inputNo = $defaultNo
    }

    return $inputNo
}

function selectProfile() {
    
    $profileNames = @(setProfileNamesArray)

    Write-Host "Select an existing terminal profile to edit" -ForegroundColor Cyan
    Write-Host "Existing Terminal Profiles:" -ForegroundColor Yellow
    $colWidth   = 32
    $colNo      = 2
    displayList $profileNames $colWidth $colNo
    Write-Host "`n"
    $arrLen     = $profileNames.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    $menuNumber = Read-Host "Enter number"
    $menuNumber = correctNumRange $menuNumber 0 $arrLen 0
    $name       = $profileNames[$menuNumber]
    Write-Host "  The profile to be edited will be: $name `n" -ForegroundColor DarkYellow
    Start-Sleep 1

    return $name
}

function selectScheme() {

    $colorSchemes = @(setSchemeArray)

    Write-Host "`nSelect an existing color scheme to apply to profile" -ForegroundColor Cyan
    Write-Host "Installed Color Schemes:" -ForegroundColor Yellow
    $colWidth   = 22
    $colNo      = 2
    displayList $colorSchemes $colWidth $colNo
    $arrLen     = $colorSchemes.length - 1
    Write-Host "`n`nSelect a number between [ 0 - $arrLen ] "
    Write-Host "`tNote: Most of 'MY' color schemes will look bad on Powershell.`n"
    $menuNumber = Read-Host "Enter number"
    $menuNumber = correctNumRange $menuNumber 0 $arrLen 0
    $color      = $colorSchemes[$menuNumber]
    Write-Host "  Color scheme will be set to: $color `n" -ForegroundColor DarkYellow
    Start-Sleep 1

    return $color
}

function selectImage() {

    $backgroundImage = @(setImageArray)

    Write-Host "`nSelect an existing picture to apply to scheme" -ForegroundColor Cyan
    Write-Host "Available Background Images:" -ForegroundColor Yellow
    $colWidth   = 33
    $colNo      = 2
    displayList $backgroundImage $colWidth $colNo
    Write-Host "`n"
    $arrLen     = $backgroundImage.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    $menuNumber = Read-Host "Enter number"
    $menuNumber = correctNumRange $menuNumber 0 $arrLen 0

    $pic        = $backgroundImage[$menuNumber]
    $roamingDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"

    if( $pic -eq "none" ) {
        Write-Host "  Background image will be: none" -ForegroundColor DarkYellow
    } elseif ( Test-Path -Path "$roamingDir\backgrounds" ) {
        Write-Host "  Background image will be:`n`tms-appdata:///roaming/backgrounds/$pic`n" -ForegroundColor DarkYellow
    } else {
        Write-Host "  Background image will be:`n`tms-appdata:///roaming/$pic`n" -ForegroundColor DarkYellow
    }
    
    Start-Sleep 1

    return $pic
}

function selectAlignment() {

    $imageAlign = @(setAlignmentArray)

    Write-Host "`nSelect an alignment to apply to background picture" -ForegroundColor Cyan
    Write-Host "Available Alignment Options:" -ForegroundColor Yellow
    $colWidth   = 12
    $colNo      = 3
    displayList $imageAlign $colWidth $colNo
    Write-Host "`n"
    $arrLen     = $imageAlign.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    $menuNumber = Read-Host "Enter number"
    $menuNumber = correctNumRange $menuNumber 0 $arrLen 0
    $align      = $imageAlign[$menuNumber]
    Write-Host "  Alignment value will be: $align `n" -ForegroundColor DarkYellow
    Start-Sleep 1

    return $align
}

function selectStretch() {

    $imageStretch = @(setStretchArray)

    Write-Host "`nSelect a stretch to apply to background picture" -ForegroundColor Cyan
    Write-Host "Available Stretch Options:" -ForegroundColor Yellow
    $colWidth   = 12
    $colNo      = 2
    displayList $imageStretch $colWidth $colNo
    Write-Host "`n"
    $arrLen     = $imageStretch.length - 1
    Write-Host "Select a number between [ 0 - $arrLen ] "
    $menuNumber = Read-Host "Enter number"
    $menuNumber = correctNumRange $menuNumber 0 $arrLen 0
    $stretch    = $imageStretch[$menuNumber]
    Write-Host "  Stretch value will be: $stretch `n" -ForegroundColor DarkYellow
    Start-Sleep 1

    return $stretch
}

function selectAplha() {

    Write-Host "`nSelect the opacity alpha transparency to apply to the background picture" -ForegroundColor Cyan
    Write-Host "Available Opacity Options:" -ForegroundColor Yellow
    Write-Host "`nSelect a number between [ 0.01 - 1.00 ]`n`tAim around ( 0.05 - 0.25 ) for a discrete watermark look.`n"
    $alpha = Read-Host "Enter number"
    $alpha = correctNumRange $alpha 0 1 0.2
    Write-Host "  Transparency value will be: $alpha `n" -ForegroundColor DarkYellow
    Start-Sleep 1

    return $alpha
}

function resetProfileThemes() {

    Write-Host "`n`nRestoring profile themes back to my preferred defaults ...`n" -ForegroundColor Yellow
    Start-Sleep 2
    
    Write-Host "`nBacking up existing profile settings ...`n" -ForegroundColor Magenta
    backupSettings

    ## Set everything back to the original git repo default theme

    Write-Host "`nResetting Git Bash ...`n" -ForegroundColor Magenta
    writeProfile "Git Bash" "Violet Light" "git-orange.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting Debian ...`n" -ForegroundColor Magenta
    writeProfile "Debian" "Apothecary White" "debian-red-smaller.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting Windows PowerShell ...`n" -ForegroundColor Magenta
    writeProfile "Windows PowerShell" "Campbell Powershell" "ps.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting cmd ...`n" -ForegroundColor Magenta
    writeProfile "cmd" "Vintage" "cmd-white.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting Developer PowerShell for VS 2019 ...`n" -ForegroundColor Magenta
    writeProfile "Developer PowerShell for VS 2019" "Campbell Powershell" "vs-white.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting Developer CMD for VS 2019 ...`n" -ForegroundColor Magenta
    writeProfile "Developer CMD for VS 2019" "VS Code" "vs-white.png" "bottomRight" "none" 0.2
}

function titleHeader( [string]$scriptName ) {

    #$scriptName = $MyInvocation.MyCommand.Name

    Write-Host "#########################################################################"
    Write-Host "## Windows Terminal Theme Selection " -ForegroundColor DarkYellow
    Write-Host "#########################################################################"
    Write-Host "##"
    Write-Host "## About:"
    Write-Host "##`t$scriptName"
    Write-Host "##`tThis script will set up a profile theme using existing resources"
    Write-Host "##"
    Write-Host "## Author:"
    Write-Host "##`tMezcel"
    Write-Host "##`thttps://github.com/mezcel/terminal-profile.git"
    Write-Host "##"
    Write-Host "## Flags:"
    Write-Host "##`t--help`t`tHelp instructions"
    Write-Host "##`t--reset`t`tRestores profiles back to my defaults "
    Write-Host "##`t--del-backups`tCleans out all temporary backups"
    Write-Host "#########################################################################"
    Write-Host "`nChanges to your settings.json will not occur until confirmation at the end.`n" -ForegroundColor Magenta
}

function helpDisplay( [string]$scriptName ) {
    
    #$scriptName = $MyInvocation.MyCommand.Name

    Write-Host "#########################################################################"
    Write-Host "## Windows Terminal Theme Selection ( Help / Notes ) " -ForegroundColor Yellow
    Write-Host "#########################################################################"
    Write-Host "##"
    Write-Host "## Launch:"
    Write-Host "##`t.\scheme_selector.ps1`t`t`t## Normal operation"
    Write-Host "##"
    Write-Host "## Launch with Flags:"
    Write-Host "##`t.\$scriptName --help`t`t## Help instructions"
    Write-Host "##`t.\$scriptName --reset`t`t## Resets profile styles"
    Write-Host "##`t.\$scriptName --del-backups`t## Delete backup saves"
    Write-Host "##"
    Write-Host "## Json Parsing:"
    Write-Host "##`tJson is parsed using Powershell's built-in Json parser."
    Write-Host "##`tThe parser will return errors if it detects comments."
    Write-Host "##`tDelete comments from settings.json for this script to work."
    Write-Host "##"
    Write-Host "## Picture files:"
    Write-Host "##`tMultimedia files should be stored within:"
    Write-Host "##`t`t$env:LOCALAPPDATA\Packages\"
    Write-Host "##`t`tMicrosoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\"
    Write-Host "##`tMake a folder named backgrounds"
    Write-Host "##`tStore *.png files in that dir"
    Write-Host "##"
    Write-Host "#########################################################################`n"
}

function main() {

    ## Profile
    $name    = selectProfile    <# Profile #>
    $color   = selectScheme     <# Color Scheme #>
    $pic     = selectImage      <# Background Picture #>

    ## Background image settings
    if ( $pic -ne "none" ) {
        $align   = selectAlignment  <# Picture Alignment #>
        $stretch = selectStretch    <# Picture Stretch #>
        $alpha   = selectAplha      <# Picture Opacity/Transparency #>
    } else {
        $align   = "center"
        $stretch = "none"
        $alpha   = 0.0
    }

    Write-Host "`n:::::::::::::::::::::::::"
    Write-Host ":: Confirmation Preview"
    Write-Host ":::::::::::::::::::::::::"

    ## Preview profile before changes are made
    showProfile $name

    ## Preview of changes to be made
    previewChanges $name $color $pic $align $stretch $alpha
    
    ## Confirmation Prompt
    $yn = ""
    While( ( $yn -ne "yes") -and ( $yn -ne "no" ) ) {
        ## Write files
        Write-Host "Proceed? "
        $yn = "n"
        $yn = Read-Host "Enter: 'yes' or 'no' "

        if ( $yn -eq "yes" ) {
            backupSettings
            writeProfile $name $color $pic $align $stretch $alpha
            exit
        }

        if ( $yn -eq "no" ) {
            Write-Host "`nNo changes will be made. Settings will remain as they were." -ForegroundColor Yellow
            Write-Host "`tThank you for playing. Bye :)`n" -ForegroundColor Green
        }

        if ( ( $yn -ne "yes") -and ( $yn -ne "no" ) ) {
            Write-Host "`nTry again." -ForegroundColor Yellow
            Write-Host "`tYou entered: ""$yn"" `n" -ForegroundColor Yellow
        }

    }
}

#####################
## Run
#####################

Clear-Host

## Title header
$scriptName = $MyInvocation.MyCommand.Name
titleHeader $scriptName

switch -Exact ( $inputArgs ) {
    "--reset" {         ## Reset to my defaults
        resetProfileThemes
		Break; }
    
    "--del-backups" {   ## rem backup settings.json
        remBackupSettings
		Break; }
    
    "--help" {          ## runtime help
        ## the file name of this .ps1 script
        $scriptName = $MyInvocation.MyCommand.Name
        helpDisplay $scriptName
        Break; }
		
    Default { main <# Main UI Theme Selector #> }

}


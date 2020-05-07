<#
    scheme_selector.ps1

    Theme selector for Windows Terminal
    https://github.com/mezcel/terminal-profile.git
#>

## External argument inputs
param( $inputArgs )

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
    $roamingDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
    
    if ( Test-Path -Path "$roamingDir\backgrounds" ) {
        $dirRoamingState = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\backgrounds\*.png"
    } else {
        $dirRoamingState = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\*.png"
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
    Start-Sleep 1

    if ( Test-Path $destination ) {
        ## Backup settings.json
        $time = (Get-Date).ToString("yyyy_MM_dd_h_m_s")
        $backupFile = "settings($time).backup"
        Copy-Item "$destination\settings.json" -Destination "$destination\$backupFile" -Force
        Start-Sleep 1
    }

    Write-Host "Done.`n`tBackup Copy:`n`t$destination\..." -ForegroundColor Green
    Write-Host "`t`t$backupFile" -ForegroundColor Green
    Start-Sleep 1

}

function remBackupSettings() {
    ## Remove backup settings files
    $destination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    Remove-Item $destination\*.backup

    Write-Host "Done.`n`tBackup files were removed from:`n`t$destination" -ForegroundColor Green
}

function writeProfile( [string]$MyName, [string]$MyColorscheme, [string]$MyBackgroundImage, 
    [string]$MyBackgroundImageAlignment, [string]$MyBackgroundImageStretchMode, [double]$MyBackgroundImageOpacity ) {

    Write-Host ""
    $settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Write-Host "Editing:`n`t$settingsLocal" -ForegroundColor Cyan
    $mySettings = Get-Content "$settingsLocal" -raw | ConvertFrom-Json
    
    $roamingDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
    if ( Test-Path -Path "$roamingDir\backgrounds" ) {
        $appPath = "ms-appdata:///roaming/backgrounds"
    } else {
        $appPath = "ms-appdata:///roaming"
    }

	$mySettings.profiles.list | % {
			if( $_.name -eq $MyName ) {
				$_.colorscheme = $MyColorscheme
				$_.backgroundImage = "$appPath/$MyBackgroundImage"
				$_.backgroundImageAlignment = $MyBackgroundImageAlignment
				$_.backgroundImageStretchMode = $MyBackgroundImageStretchMode
				$_.backgroundImageOpacity = $MyBackgroundImageOpacity
			}
		}
		
    $mySettings | ConvertTo-Json -depth 32 | set-content "$settingsLocal"
    Write-Host "Done.`n`tEdited:`n`t$settingsLocal `n" -ForegroundColor Green
    Start-Sleep 1
}

##############################################
## Preview Pre-Changes State ( settings.json )
##############################################

function showProfile( [string]$MyName ) {

	$settingsLocal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $mySettings = Get-Content "$settingsLocal" -raw | ConvertFrom-Json

	$mySettings.profiles.list | % {
        if( $_.name -eq $MyName ) {                
            Write-Host ""
            Write-Host "Current Profile Setting:`n" -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tProfile Name`t`t: $MyName" -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tScheme Color`t`t:"$_.colorscheme.ToString() -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tBackground Picture`t:"$_.backgroundImage.ToString() -ForegroundColor DarkYellow -BackgroundColor Black
            Write-Host "`tPicture Allignment`t:"$_.backgroundImageAlignment.ToString() -ForegroundColor DarkYellow -BackgroundColor Black
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
    Write-Host "`tBackground Picture`t: ms-appdata:///roaming/backgrounds/$pic " -ForegroundColor Red -BackgroundColor Black
    Write-Host "`tPicture Allignment`t: $align " -ForegroundColor Red -BackgroundColor Black
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

function selectProfile() {
    
    $profileNames = @(setProfileNamesArray)

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
    Write-Host "You selected: "$name -ForegroundColor DarkYellow
    Start-Sleep 1

    return $name
}

function selectScheme() {

    $colorSchemes = @(setSchemeArray)

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
    Write-Host "You selected: "$color -ForegroundColor DarkYellow
    Start-Sleep 1

    return $color
}

function selectImage() {

    $backgroundImage = @(setImageArray)

    Write-Host ""
    Write-Host "Select an existing picture to apply to scheme" -ForegroundColor Cyan
    Write-Host "`tThis app is set to scan for ( *.png ) images within this dir:" -ForegroundColor Cyan
    Write-Host "`t$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\backgrounds" -ForegroundColor Cyan
    Write-Host "`tOtherwise it will scan the parent \RoamingState directory" -ForegroundColor Cyan
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

    $roamingDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState"
    if ( Test-Path -Path "$roamingDir\backgrounds" ) {
        Write-Host "You selected: ms-appdata:///roaming/backgrounds/$pic" -ForegroundColor DarkYellow
    } else {
        Write-Host "You selected: ms-appdata:///roaming/$pic" -ForegroundColor DarkYellow
    }
    
    Start-Sleep 1

    return $pic
}

function selectAlignment() {

    $imageAlign = @(setAlignmentArray)

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
    Write-Host "You selected: "$align -ForegroundColor DarkYellow
    Start-Sleep 1

    return $align
}

function selectStretch() {

    $imageStretch = @(setStretchArray)

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
    Write-Host "You selected: "$stretch -ForegroundColor DarkYellow
    Start-Sleep 1

    return $stretch
}

function selectAplha() {

    Write-Host ""
    Write-Host "Select the opacity alpha transparacy to apply to the background picture" -ForegroundColor Cyan
    Write-Host "Available Opacity Options:" -ForegroundColor Yellow
    Write-Host "Select a number between [ 0 - 1 ]`n`tAim arround ( 0.1 - 0.3 ) for a more discrete look.`n"
    $alpha = Read-Host "Enter number"
    if ( isNumeric $alpha ) {
        if (( $alpha -gt 1 ) -or ( $alpha -gt 1 )) {
            Write-Host "You entered $alpha, that value is out of range."
            $alpha = 1
        }
    } else {
        Write-Host "You entered $alpha, that value is out of range."
        $alpha = 1
    }
    Write-Host "Transparency vale will be: "$alpha -ForegroundColor DarkYellow
    Start-Sleep 1

    return $alpha
}

function resetProfileThemes() {

    Write-Host "`n`nRestoring profile themes back to my prefered defaults ...`n" -ForegroundColor Yellow
    Start-Sleep 2
    
    Write-Host "`nBacking up existing profile settings ...`n" -ForegroundColor Magenta
    backupSettings

    ## Set everything back to the original git repo default theme

    Write-Host "`nResetting Git Bash ...`n" -ForegroundColor Magenta
    writeProfile "Git Bash" "Violet Light" "git-orange.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting Debian ...`n" -ForegroundColor Magenta
    writeProfile "Debian" "Apothecary White Light" "debian-red-smaller.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting Windows PowerShell ...`n" -ForegroundColor Magenta
    writeProfile "Windows PowerShell" "Campbell Powershell" "ps.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting cmd ...`n" -ForegroundColor Magenta
    writeProfile "cmd" "Vintage" "cmd-white.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting Developer PowerShell for VS 2019 ...`n" -ForegroundColor Magenta
    writeProfile "Developer PowerShell for VS 2019" "Campbell Powershell" "vs-white.png" "bottomRight" "none" 0.2

    Write-Host "`nResetting Developer CMD for VS 2019 ...`n" -ForegroundColor Magenta
    writeProfile "Developer CMD for VS 2019" "VS Code" "vs-white.png" "bottomRight" "none" 0.2
}


function titleHeader() {
    Write-Host "#########################################################################"
    Write-Host "## Windows Terminal Theme Selection "
    Write-Host "#########################################################################"
    Write-Host "##"
    Write-Host "## About:"
    Write-Host "##`tThis script will set up a profile theme with existing resources"
    Write-Host "##"
    Write-Host "## Note:"
    Write-Host "##`tsettings.json must be clear of all comment"
    Write-Host "##`tcomments will be interpreted as json file sytax errors"
    Write-Host "##"
    Write-Host "## Author:"
    Write-Host "##`tMezcel"
    Write-Host "##`thttps://github.com/mezcel/terminal-profile.git"
    Write-Host "##"
    Write-Host "## Flags:"
    Write-Host "##`t--help`t`tHelp instructions (n/a)"
    Write-Host "##`t--reset`t`tRestres profiles back to my defaults "
    Write-Host "##`t--rem-backups`tCleans out all temporary backups"
    Write-Host "##`t--import`tImport a json file theme (n/a)"
    Write-Host "#########################################################################"
    Write-Host "`nChanges to your settings.json will not occur untill confirmation at the end.`n" -ForegroundColor Magenta
}


function main() {

    ## Profile
    $name = selectProfile

    ## Color Scheme
    $color = selectScheme

    ## Background Picture
    $pic = selectImage

    ## Picture Alignment
    $align = selectAlignment

    ## Picture Stretch
    $stretch = selectStretch

    ## Picture Opacity/Transparency
    $alpha = selectAplha

    Write-Host "`n::"
    Write-Host ":: Confirmation Preview"
    Write-Host "::"

    ## Preview profile before changes are made
    showProfile $name

    ## Preview of changes to be made
    previewChanges $name $color $pic $align $stretch $alpha
    
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
            Write-Host "`nNo Changes were applied. Try again when you are ready." -ForegroundColor Yellow
            Write-Host "`tThanks for playing. Bye :)" -ForegroundColor Green
        }

        if ( ( $yn -ne "yes") -and ( $yn -ne "no" ) ) {
            Write-Host "`nTry again." -ForegroundColor Yellow
            Write-Host "`tYou entered: $yn`n" -ForegroundColor Yellow
        }

    }

    ## Manually Edit settings.json in notepad
    # notepad $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
    ## Manually Manage Backup files in windows explorer
    # explorer $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
    ## Manually Manage Backup dirs in windows explorer
    # explorer $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe
}

#####################
## Run
#####################

Clear-Host

## Title header
titleHeader

$inputArgs.ToString()
switch -Exact ( $inputArgs ) {

    "--reset" {         ## Reset to my defaults
        resetProfileThemes; Break }        
    "--rem-backups" {   ## rem backup settings.json
        remBackupSettings; Break }   
    "--import" { 
        Write-Host "Import json feature not done yet`n" -ForegroundColor Yellow;
        Start-Sleep 1; } 
    "--help" { 
        Write-Host "Help feature not done yet`n" -ForegroundColor Yellow;
        Start-Sleep 1; } 
    Default { main }    ## Main UI Theme Selector

}


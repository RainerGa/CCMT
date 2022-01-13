#requires -version 4
<#
    .SYNOPSIS
    This script installs the Toolset CCMT

    .DESCRIPTION
    This script installs the Toolset CCMT or Parts of it to a specified Location

    .PARAMETER Location
    Mandatory
    Specifies the Install Location.
    Default = C:\Users[your Username]\AppData\Roaming\ccmtools

    .INPUTS
    Location is optional, if you want a different Directory

    .OUTPUTS
    Log File
    The script log file stored in C:\Windows\Temp\setupccmt.log

    .NOTES
    Version:        1.0
    Author:         Max Kliemt
    Creation Date:  12.01.2022
    Purpose/Change: Initial script development

    .EXAMPLE
    setup.ps1 -Location "C:\Windows\Temp"
    Installs the Toolset to the "C:\Windows\Temp" Folder
#>
#---------------------------------------------------------[Script Parameters]------------------------------------------------------
Param (
    [parameter(Mandatory=$true)][string]$Location
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
#Set Error Action to Silently Continue
ErrorActionPreference = 'SilentlyContinue'
#Import Modules & Snap-ins
Import-Module .\test.ps1
#----------------------------------------------------------[Declarations]----------------------------------------------------------
#Script Version
sScriptVersion = '1.0'
#Log File Info
sLogPath = 'C:\Windows\Temp'
sLogName = 'setupccmt.log'
sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------
function setuplogging {
    [CmdletBinding()]
    param ($Destination)
    
    begin {
        $Location = Get-Location
        $LoggingLocation = @("PSLogging.ps1", "CCMT_SOURCE\Logging\PSLogging.ps1")
    }
    
    process {
        try {
            foreach ($item in $LoggingLocation) {
                $completepath = Join-Path -Path $Location -ChildPath $item
                if (Test-Path -Path $completepath) {
                    Import-Module $completepath
                    $a = $true
                }
                if (not $a) {
                    $DestFather = Split-Path -Path $Destination -Parent
                    $LogDestination = Join-Path -Path $DestFather -ChildPath "CCMT_SOURCE\Logging\PSLogging.ps1"
                    Invoke-WebRequest "https://raw.githubusercontent.com/RainerGa/CCMT/main/CCMT_SOURCE/Logging/PSLogging.ps1" -OutFile $LogDestination
                }
            }
        }
        catch {
            Write-Host "Fehler beim runterladen des Logging Modules"
            $host.exit(1)
        }
    }
    
    end {
        Import-Module $LogDestination
    }
}
Function setup {
    Param ($Location)
    Begin {
        Write-LogInfo -LogPath $sLogFile -Message "Installation started"
        testdirectory -installPath $Location
        $url = "https://github.com/RainerGa/CCMT/archive/main.zip"
        $parentlocation = Split-Path -Path $Location -Parent
        $output = Join-Path -Path $parentlocation -ChildPath "\main.zip"
        $OpenCV = "https://github.com/opencv/opencv/releases/download/4.5.5/opencv-4.5.5-vc14_vc15.exe"
    }
    Process {
        Try {
            Write-LogInfo -LogPath $sLogFile -Message "Downloading Archive from GitHub"
            Invoke-WebRequest -Uri $url -OutFile $output
            Write-LogInfo -LogPath $sLogFile -Message "Extracting Archive" 
            Expand-Archive -Path $output -DestinationPath $Location 
        }
        Catch {
            Write-LogError -LogPath $sLogFile -Message _.Exception -ExitGracefully
            Break
        }
    }
    End {
        If ($?) {
            Write-LogInfo -LogPath $sLogFile -Message 'Completed Successfully.'
            Write-LogInfo -LogPath $sLogFile -Message ' '
        }
    }
}


function testdirectory 
{
    [cmdletbinding(ConfirmImpact = "Medium")]

    param (
        [string]$installPath
    )
    
    begin {
        Write-LogInfo -LogPath $sLogFile -Message "Checking Location: $installPath"
        if ($installPath -match "\.") {
            $installPath = Split-Path -Path $installPath
        }
    }
    
    process {
        Try {
           if (Test-Path -Path $installPath -IsValid) {
                Write-LogInfo -LogPath $sLogFile -Message "Path is valid"
                if (not Test-Path -Path $installPath) {
                    Write-LogInfo -LogPath $sLogFile -Message "Path does not yet exist fully, creating the missing folder(s)"
                    Write-Host "Creating Missing Directorys"
                    New-Item -Path $installPath -ItemType Directory
                    return 0
                }
                else {
                    Write-LogInfo -LogPath $sLogfile -Message "Path exists"
                    return 0
                }
            }
            else {
                Write-LogInfo -LogPath $sLogFile -Message "Path is not Valid, waiting for User Input and checking again"
                # PromptForChoice Args
                $Title = "Installation Location is not Valid. Please Enter a Valid Location, for Example 'C:\Windows\Temp'?"
                $Prompt = "Do you want to continue?"
                $Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No", "&Cancel")
                $Default = 1
                
                # Prompt for the choice
                $Choice = $host.UI.PromptForChoice($Title, $Prompt, $Choices, $Default)
                
                # Action based on the choice
                switch($Choice)
                {
                    0 { $installPath = Read-Host "Please enter new Location: "
                        Write-LogInfo -LogPath $sLogFile -Message "Entered new Path: $installPath"
                        testdirectory($installPath)
                        break}
                    1 { Write-Host "No - exiting Program"
                        Write-LogInfo -LogPath $sLogFile -Message "Exiting Program"
                        $host.Exit(0)
                    }
                    2 { Write-Host "Cancel - Aborting"
                        Write-LogInfo -LogPath $sLogFile -Message "Aborting Program"    
                        $host.Exit(1)
                    }
                }
            }
        }
        Catch {
            Write-LogError -LogPath $sLogFile -Message _.Exception -ExitGracefully
            Break
        }
    }
}




#-----------------------------------------------------------[Execution]------------------------------------------------------------
Start-Log -LogPath sLogPath -LogName sLogName -ScriptVersion sScriptVersion
setuplogging
setup($Location)

#Script Execution goes here
Stop-Log -LogPath sLogFile
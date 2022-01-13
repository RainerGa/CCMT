#requires -version 4
<#
    .SYNOPSIS
    This script installs the Toolset CCMT

    .DESCRIPTION
    This script installs the Toolset CCMT or Parts of it to a specified Location

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
    
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
#Set Error Action to Silently Continue
ErrorActionPreference = 'SilentlyContinue'
#Import Modules & Snap-ins
Import-Module .\CCMT_SOURCE\Logging\PSLogging.ps1
#----------------------------------------------------------[Declarations]----------------------------------------------------------
#Script Version
sScriptVersion = '1.0'
#Log File Info
sLogPath = 'C:\Windows\Temp'
sLogName = 'setupccmt.log'
sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function testdirectory 
{

    param (
        
    )
    
    begin {
        Write-LogInfo -LogPath $sLogFile -Message ""
        $opencvuri = "https://github.com/opencv/opencv/releases/download/4.5.5/opencv-4.5.5-vc14_vc15.exe"
    }
    
    process {
        Try {
           
        }
        Catch {
            Write-LogError -LogPath $sLogFile -Message _.Exception -ExitGracefully
            Break
        }
    }
}




#-----------------------------------------------------------[Execution]------------------------------------------------------------
Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion


#Script Execution goes here
Stop-Log -LogPath $sLogFile
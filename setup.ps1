#requires -version 4
<#
    .SYNOPSIS
    This script installs the Toolset CCMT

    .DESCRIPTION
    This script installs the Toolset CCMT or Parts of it to a specified Location

    .PARAMETER Location
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
    [string]$Location
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
#Set Error Action to Silently Continue
ErrorActionPreference = 'SilentlyContinue'
#Import Modules & Snap-ins
Import-Module PSLogging
#----------------------------------------------------------[Declarations]----------------------------------------------------------
#Script Version
sScriptVersion = '1.0'
#Log File Info
sLogPath = 'C:\Windows\Temp'
sLogName = 'setupccmt.log'
sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function setup {
    Param ($Location)
    Begin {
        Write-LogInfo -LogPath sLogFile -Message "Installation started, Location: $Location"
    }
    Process {
        Try {
            <code goes here>
        }
        Catch {
            Write-LogError -LogPath sLogFile -Message _.Exception -ExitGracefully
            Break
        }
    }
    End {
        If ($?) {
            Write-LogInfo -LogPath sLogFile -Message 'Completed Successfully.'
            Write-LogInfo -LogPath sLogFile -Message ' '
        }
    }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------
Start-Log -LogPath sLogPath -LogName sLogName -ScriptVersion sScriptVersion
#Script Execution goes here
Stop-Log -LogPath sLogFile
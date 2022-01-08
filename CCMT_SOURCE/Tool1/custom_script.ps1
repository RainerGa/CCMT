# **********************************************************************************************************
#       Contactcenter Mini Tool
#       This Script is an Example Implementation. It needs to be customized for your needs!
#       This Source works only if called from "ccmt_pn2ticket.ps1"!
#
#       @author:         Rainer G.
#       @version:        0.1
#
#       Filename:       custom_script.ps1
#                       Means: Customer spezific implementation
#       Environment:
#                       Windows
#                           Installationpath:       %APPDATA%\Roaming\ccmtools\
#                           Custom Run Script:      custom_script.ps1
#
# FAQ:
#   Q:  What if a new CCMT Version will be released
#   A:  You do not need to write a new custom_script.ps1! 
#   ++++++
#   Q:  Is this a full implemenation of a full fledged solution to do ... what?
#   A:  In this Exemple Implementation it opens a browser with the informations the script ccmt_pn2ticket.ps1 gathered before
#   ++++++
# **********************************************************************************************************
# Program Parameters

<#
Do anything with the analysed data
In this case, get the Name of a User cause of the calling phonenumber
#>
function do_work_after_analyse {
    # open phonenr2customer.csv
    # search for Customer "Name" and "Vorname" (Surname for english speaking people)
    $line = Get-Content "$global:PROG_HOME\phonenr2customer.csv" | Where-Object { $_.Contains($global:SCANNED_TEXT) }

    if ([string]::IsNullOrWhitespace($line)) {
      # Nothing found stop Working
      Write-Verbose "Nothing found, working will stop"
      return;
    }

    $a_line = $line.split(";");
    Write-Verbose $a_line[2];

    # open customer2ticket.csv
    # search the Ticketnr. and use for this "Name" and "Vorname" ($a_line[1] + $a_line[2])
    $ticket_line = Get-Content "$global:PROG_HOME\customer2ticket.csv" | Where-Object { $_.Contains($a_line[1] +";"+ $a_line[2]) }

    $a_ticket_line = $ticket_line.split(";")
    Write-Verbose $a_ticket_line[2];
    $url = "https://youticketsystem.com?egal="+ $a_ticket_line[2]

    # Open Ticket with Ticketnumber in your Ticketsystem
    # Start-Process ("https://youticketsystem.com&"+ $a_ticket_line[2]);
    [system.Diagnostics.Process]::Start("msedge",$url)
}
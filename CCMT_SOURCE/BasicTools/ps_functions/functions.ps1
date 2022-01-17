# **********************************************************************************************************
#       Powershell Functions for CCMT
#
#       @author:         Rainer G.
#       @version:        0.1
#
#       Filename:       ccmt_functions.ps1
#
#       Environment:
#                       Windows
#                           Installationpath:       [Installation Directory]
#
#                           
# FAQ:
#   Q:  Usage
#   A:   Import it with the following Syntax: ". ./functions.ps1"
#   ++++++
#   Q:  Why does CCMT did not use the default powershell module mechanism
#   A:  CCMT should work without any higher system rights; without any installation and so on; Copy and be happy :-)
#   ++++++
#   Q:  What is mean with [Installation Directory]
#   A:  See: CCMT Project Tool1 Documentation
# **********************************************************************************************************

# Needed to move the mouse
Add-Type -AssemblyName System.Windows.Forms

<#
Move the Mouse to a Cursor Position

Parameter 1: xpos = X Coordinate
Parameter 2: ypos = Y Coordinate

There is NO "try-catch Implementation" included

return Original Mouse Cursor Position
#>
function move_mouse ($xpos, $ypos) {
    
    # Safe current Mouse Position
    $pos = [System.Windows.Forms.Cursor]::Position;
    
    # Move the Mouse to the new position
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y);
    
    return $pos;
}

<#
Clicks the Mouse Button

Parameter 1: buttontype = left, middle, right

returns nothing

This Code is copied from
https://social.technet.microsoft.com/Forums/windowsserver/de-DE/1f89491b-0c0d-48d0-874c-97ca96127a8e/script-using-windows-powershell-ise-to-move-mouse-and-control-keyboard?forum=winserverpowershell
#>
function Click-MouseButton {
    param(
        [string]$Button,
        [switch]$help)
    $HelpInfo = @'
Function : Click-MouseButton
Purpose  : Clicks the Specified Mouse Button
Usage    : Click-MouseButton [-Help][-Button x]
           where      
                  -Help         displays this help
                  -Button       specify the Button You Wish to Click {left, middle, right}

'@
    if ($help -or (!$Button)) {
        write-host $HelpInfo
        return
    }
    else {
        $signature = @'
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
        $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
        if ($Button -eq "left") {
            $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
            $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
        }
        if ($Button -eq "right") {
            $SendMouseClick::mouse_event(0x00000008, 0, 0, 0, 0);
            $SendMouseClick::mouse_event(0x00000010, 0, 0, 0, 0);
        }
        if ($Button -eq "middle") {
            $SendMouseClick::mouse_event(0x00000020, 0, 0, 0, 0);
            $SendMouseClick::mouse_event(0x00000040, 0, 0, 0, 0);
        }
    }
}
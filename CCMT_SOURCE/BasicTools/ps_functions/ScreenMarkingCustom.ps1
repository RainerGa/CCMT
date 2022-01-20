# **********************************************************************************************************
#       Powershell Function for CCMT
#       let you mark a screen section.
#
#       @author:         Rainer G.
#       @version:        0.1
#
#       Filename:       screen_marking.ps1
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

# Original Code from:
# https://www.linkedin.com/pulse/powershell-scripting-ui-screenshot-automation-sergey-astrakhantsev
Add-Type -AssemblyName System.Windows.Forms

$screen_marking_form = [System.Windows.Forms.Form]::new()                              
$screen_marking_form.WindowState = "Normal"                                            #redefine window to avoid min and max states as non-resizeable
$screen_marking_form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None    #make window borderless and w/o header
$screen_marking_form.Opacity = 0.01  
$screen_marking_form.ShowInTaskbar = $false                                            #hide in taskbar
$screen_marking_form.Text = "Capture area"                                             #window name in Task Manager
$screen_marking_form.StartPosition = [System.Windows.Forms.FormStartPosition]::Manual  #or just [Int] 0 to work with additional displays if available
$screen_marking_form.DesktopBounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds #equate window size with full screen dimensions of primary display

$Script:FormStartPosition = $null #the window initial position, used as a flag that it is set

#handler of window events on pressing keys
$screen_marking_form.add_KeyDown({
        #close window on pressing ESC - quit
        if ($_.KeyCode -eq "Escape") {
            $screen_marking_form.Close()
        }
    })

#handler of window events on pressing mouse buttons
$screen_marking_form.Add_MouseDown({
        #close window on pressing Right-MB - quit
        if ($_.Button -eq [System.Windows.Forms.MouseButtons]::Right) {
            $screen_marking_form.Close()
        }

        #set window initial position on pressing Left-MB
        if ($_.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
            $Script:FormStartPosition = [System.Windows.Forms.Cursor]::Position

            $screen_marking_form.DesktopBounds = [System.Drawing.Rectangle]::new($FormStartPosition.X, $FormStartPosition.Y, 0, 0)
            $screen_marking_form.Opacity = 0.5  
            $screen_marking_form.BackColor = [System.Drawing.Color]::CornflowerBlue
        }
    })      

#handler of window events on moving mouse
$screen_marking_form.Add_MouseMove({
        #define new window size if initial position is already set - LeftMB still down
        if ($Script:FormStartPosition) {
            $MousePosition = [System.Windows.Forms.Cursor]::Position #get current cursor position
            $Xs = ($Script:formStartPosition.X, $MousePosition.X) | Sort-Object
            $Ys = ($Script:formStartPosition.Y, $MousePosition.Y) | Sort-Object
            $screen_marking_form.DesktopBounds = [System.Drawing.Rectangle]::new($Xs[0], $Ys[0], ($Xs[1] - $Xs[0]), ($Ys[1] - $Ys[0])) #set window position and size
        }
    })

#handler of window events on moving mouse out of the window - changing current display for the window not configured yet
$screen_marking_form.Add_MouseLeave({
        $screen_marking_form.Hide() #workaround to capture mouse cursor not only in displayed window
        $position = [System.Windows.Forms.Cursor]::Position # get mouse position
        $screen = [System.Windows.Forms.Screen]::FromPoint([System.Drawing.Point]::new($Position.X, $Position.Y)) #find out which screen is under mouse cursor
        
        #Write-Host $screen.DeviceName - debugging
        $screen_marking_form.DesktopBounds = $screen.Bounds #set window position equal to active screen
        $screen_marking_form.Show()
    })

#handler of window events on releasing mouse buttons
$screen_marking_form.Add_MouseuP({
        #on releasing Left_MB set capture flag and close window
        if ($_.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
            Write-host $screen_marking_form.Height
            Write-host $screen_marking_form.Width
            Write-host $screen_marking_form.DesktopLocation.X
            Write-host $screen_marking_form.DesktopLocation.Y
            $screen_marking_form.Close() 
        }
    })

# Out-Null suppress the "cancel" Message at Close()
$screen_marking_form.ShowDialog() | Out-Null
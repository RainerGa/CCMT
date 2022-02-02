# **********************************************************************************************************
#       Contactcenter Mini Tool to resolve Phonenumber to Customer/Ticketnumber or anything else.
#       The "resolve to" can/needs to be coded by yourself :-)
#       "custom_script.ps1" is part of this project (to show an example implementation) 
#
#       @author:         Rainer G.
#       @version:        0.3
#
#       Filename:       ccmt_pn2ticket.ps1
#                       Means: Contactcenter Mini Tools "Phonenummer to Ticket" resolver
#       Environment:
#                       Windows
#                       Details see: https://github.com/RainerGa/CCMT/tree/main/CCMT_SOURCE/Tool1
#
# FAQ:
#   Q:  What are the steps after installation
#   A:   1. Start the Script with Parameter (.\ccmt_pn2ticket.ps1 -config_mouse_scan_area) 
#        2. Add the Script to your Desktop (Link) and add an Keyboard Shortcut
#   ++++++
#   Q:  What can I do if my ccmt_config.xml File will not be found
#   A:  Download the File from github there is no routine to create the file clean and new :-()
#   ++++++
#   Q:  The Software does not work if one of the coordinates is "x=0,Y=0" (Left Corner of your screen)
#   A:  The Method ".isEmpty" of the Class System.Drawing.Point does return a TRUE.
#       Move your Mouse little bit in one direction. So x or y is not "0" anymore. (or edit ccmt_config.xml manual)
# **********************************************************************************************************
# Program Parameters
Param(
    # Start with config_mouse_scan_area at the first start of the program
    [Parameter(Mandatory=$False)]
    [switch]$config_mouse_scan_area
);

Write-Host ("1")

# **********************************************************************************************************
# Load Classes
# - Set on Script Begin, cause in Powershell 64-bit it needs to be...
# **********************************************************************************************************
# Needed to get the Mouse coordinates
Add-Type -AssemblyName System.Windows.Forms

# Integrates the "do_work_after_analyse" Function
# . "$PSScriptRoot\custom_script.ps1"

# **********************************************************************************************************
# Variables (for customication)
# **********************************************************************************************************
# Debugging Messages Config ("Continue" for activate; "SilentlyContinue" for deactivate)
$VerbosePreference = "Continue" # SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend

# Name of the softphone program. This is used to identify the Prozess ID and bring the Window of the Softphone in the foreground
$softphone_program = "notepad"

# This was not nessecary :-) But is part of this software
$a_phone_number_types = @("+49[0-9]*","0800[0-9]*", "0[0-9]*");


# **********************************************************************************************************
# Global Variables (Change the path variables if you do not follow the install description)
# **********************************************************************************************************
$global:PROG_HOME = $env:APPDATA +"\ccmtools";
$global:CAPTURE2TEXT_PATH = $global:PROG_HOME +"\Capture2Text";
$global:CUSTOM_SCRIPT = $global:PROG_HOME + "\custom_script.ps1";
$global:CONFIG_FILE = $global:PROG_HOME + "\ccmt_config.xml";
# If this Variable is not set to = "" there is a error output: <Error>
$global:SCANNED_TEXT = "";

$unique_nr;             # unique Number for every analysation

[System.Drawing.Point]$global:MOUSE_FIRST = New-Object -TypeName System.Drawing.Point;       # Mouse First Coordinate for Screenshot
[System.Drawing.Point]$global:MOUSE_SECOND = New-Object -TypeName System.Drawing.Point;       # Mouse Second Coordinate for Screenshot

# **********************************************************************************************************
# Functions
# **********************************************************************************************************
<#
Write XML Config File ($CONFIG_FILE)
#>
function write_config_file {

    [xml]$xmlDoc = "";
    try {
        Write-Verbose $global:CONFIG_FILE
        [xml]$xmlDoc = [System.Xml.XmlDocument](Get-Content $global:CONFIG_FILE -ErrorAction Stop);
    } catch {
        Write-Verbose "XML can not be found for writing. Please see FAQ in Sourcecode to get hints."
    }

    $xmlDoc.ccmt.pn2ticket.coordinates_of_rectangle.first_point.x = $global:COORDINATES.left_x_coordinate.ToString();
    $xmlDoc.ccmt.pn2ticket.coordinates_of_rectangle.first_point.y = $global:COORDINATES.left_y_coordinate.ToString();

    $xmlDoc.ccmt.pn2ticket.coordinates_of_rectangle.second_point.x = $global:COORDINATES.right_x_coordinate.ToString();
    $xmlDoc.ccmt.pn2ticket.coordinates_of_rectangle.second_point.y = $global:COORDINATES.right_y_coordinate.ToString();

    $xmlDoc.Save($global:CONFIG_FILE);
}

<#
Read XML Config File ($CONFIG_FILE)
#>
function read_config_file {

    [xml]$xmlDoc = "";
    try {
        Write-Verbose $global:CONFIG_FILE
        [xml]$xmlDoc = [System.Xml.XmlDocument](Get-Content $global:CONFIG_FILE -ErrorAction Stop);
    } catch {
        Write-Verbose "XML can not be found for reading. Please see FAQ in Sourcecode to get hints."
    }

    $global:MOUSE_FIRST.X = $xmlDoc.ccmt.pn2ticket.coordinates_of_rectangle.first_point.x;
    $global:MOUSE_FIRST.Y = $xmlDoc.ccmt.pn2ticket.coordinates_of_rectangle.first_point.y;

    $global:MOUSE_SECOND.X = $xmlDoc.ccmt.pn2ticket.coordinates_of_rectangle.second_point.x;
    $global:MOUSE_SECOND.Y = $xmlDoc.ccmt.pn2ticket.coordinates_of_rectangle.second_point.y;

}

<#
Create a unique ID.
Created as extra function for easier customization (if necessary)
#>
function create_new_unique_nr {
    return [guid]::NewGuid()    
}

<#
Use Capture2Text to take a screenshot & analyse it with tesseract ocr technique
@return OCR recogniced Text/Numbers/Characters
#>
function take_screenshot_return_ocr_text {
    # Capture2Text>Capture2Text_CLI.exe --screen-rect "x1 y1 x2 y2"
    $para = $global:MOUSE_FIRST.X.toString() +" "+$global:MOUSE_FIRST.Y.toString() +" "+$global:MOUSE_SECOND.X.toString() +" "+$global:MOUSE_SECOND.Y.toString();
    Write-Verbose ("XY Parameter:"+ $para);
    
    $ocr_result = & "$global:CAPTURE2TEXT_PATH\Capture2Text_CLI.exe" --screen-rect `"$para`"
    Write-Verbose ("OCR Scan Result:"+ $ocr_result);

    # Analyse the Result and use for this: $a_phone_number_types
    # Remove "/", " "
    $ocr_result = $ocr_result.Replace("/","");
    $ocr_result = $ocr_result.Replace(" ","");
    $ocr_result = $ocr_result.Replace("+49 ","0");
    Write-Verbose $ocr_result;

    return $ocr_result;
}

<#
Do anything with the analysed data
In this case, get the Name of a User cause of the calling phonenumber
do_work_after_analyse -> see custom_script.ps1 
#>

<#
Brings the Softphone Client in the Foreground so that OCR scanning will work correct

Be aware of: This works only correct if there ist only ONE Prozess to bring in foreground!!!
#>
function bring_softphone_in_foreground {
    Enum ShowStates
    {
      Hide = 0
      Normal = 1
      Minimized = 2
      Maximized = 3
      ShowNoActivateRecentPosition = 4
      Show = 5
      MinimizeActivateNext = 6
      MinimizeNoActivate = 7
      ShowNoActivate = 8
      Restore = 9
      ShowDefault = 10
      ForceMinimize = 11
    }
    
    
    # (see also www.pinvoke.net)
    $code = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    
    # add signature as new type to PowerShell (for this session)
    $type = Add-Type -MemberDefinition $code -Name myAPI -PassThru
    
    # get the process of the Softphone Client
    $process = Get-Process $softphone_program
    $hwnd = $process.MainWindowHandle
    
    # Shows the Softphone Client
    $type::ShowWindowAsync($hwnd, [ShowStates]::ShowDefault)

}


# **********************************************************************************************************
# main
# **********************************************************************************************************
function main {
    Write-Host ("2")
    if ($config_mouse_scan_area) {
        Write-Host ("Select the screen area you want to scan (with your mouse)")
        .\ScreenMarkingCustom.ps1
        write_config_file
        Write-Host ("Config Informations written to $global:CONFIG_FILE");
        exit;
    }

    # read coordinates in config file
    $unique_nr = create_new_unique_nr;
    Write-Verbose ("Unique Number: "+ $unique_nr);

    read_config_file;

    bring_softphone_in_foreground;
    
    $global:SCANNED_TEXT = take_screenshot_return_ocr_text;

    Write-Verbose ("The following Text was scanned per OCR: "+ $global:SCANNED_TEXT);

    # This is part of the main method cause of better customization/finding for new Users
    if (Test-Path -Path $global:CUSTOM_SCRIPT -PathType Leaf) {
        Write-Verbose "custom Script File will be executed! Not the default Way will be used!"

        # Implement it
        exit;
    }

    Write-Verbose "Default Way will be used!"

    do_work_after_analyse;

    
}


main;


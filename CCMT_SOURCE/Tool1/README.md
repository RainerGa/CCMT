# <p align="center">Install Instruction</p>

1. Download a productive release of CCMT, and extract the ZIP in a separate folder on your PC*
   1. Create an Installation Directory (Example: C:\Users\[your Username]\CCMT)
   2. copy ccmt_pn2ticket.ps1, functions.ps1 in this (2.) Directory
2. go to %APPDATA% and create directory "ccmtools" (Example: C:\Users\[your Username]\AppData\Roaming\ccmtools
   1. Download Capture2Text: https://sourceforge.net/projects/capture2text/files/Dictionaries/
   2. Extract Capture2Text in this (3.) Directory
   3. Copy customer2ticket.csv, ccmt_config.xml an phonenr2customer.csv in the directory (3.)


After this steps you should see the following directory structure on your PC:

`%APPDATA%/ccmtools`

                  /Capture2Text     (Directory)

                  /ccmt_config.xml

                  /customer2ticket.csv

                  /custom_script.ps1    (your custom script, example is part of this project)
                  
                  /phonenr2ticket.csv
                  
                  
                  
                  
                  

**and**

`[your Directory Location]`

                ccmt_pn2ticket.ps1
                functions.ps1

PC: Means a Windows Computer or a Windows Terminalserver Desktop

# Usage (Example)
Please Read the Description for Tool1 of this project! 

# External Dependencies
Capture2Text

# Environment
Tested with Windows 10 

# FAQ
See FAQ Secion in the Sourcecode of the powershell script: **ccmt_pn2ticket.ps1**

This software is not a "one click and be happy" Solution! You need to be able to open and read the powershell Script.
There are Sections you need to configure and there are sections you do not need to change.
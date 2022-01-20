REM Description
REM 
REM This is a really simple solution to build a test environment out of the Download of a CCMT release
REM It is NOT a full installation solution! There is NO Error Handling!
REM Config files in %APPDATA\ccmtools will not be deleted or overwritten
REM 
REM
REM       Author: RainerGa
REM       Version: 0.1
REM 
REM Manual Work todo
REM ---------------- !!!!!!!
REM Install Capture2Text
REM Copy xml, csv Files yourself. If they are already present they will not overwritten
REM ---------------- !!!!!!!

echo "Delete and create CCMT Installation DIR"
rmdir %HOMEPATH%\CCMT
mkdir %HOMEPATH%\CCMT

echo "create CCMT custom DIR"
mkdir %APPDATA%\ccmtools

copy ..\..\Tool1\ccmt_pn2ticket.ps1 %HOMEPATH%\CCMT\
copy ..\..\BasicTools\ps_functions\*.ps1 %HOMEPATH%\CCMT\
copy ..\..\BasicTools\TemplateMatching\*.jar %HOMEPATH%\CCMT\

echo "Install TestGUIs"
copy ..\..\TestingTools\UCClientGUI\bin\*.* %HOMEPATH%\CCMT\


echo "Download manually Capture2Text and copy it to %APPDATA%\ccmtools\, see documentation!"
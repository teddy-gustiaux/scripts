@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

REM Get script directory
SET startDirectory=%~dp0

REM Generate datetime to avoid shortcut duplication error
set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
set secs=%time:~6,2%
if "%secs:~0,1%" == " " set secs=0%secs:~1,1%
set year=%date:~0,4%
set month=%date:~5,2%
set day=%date:~8,2%
set datetime=%year%%month%%day%%hour%%min%%secs%

REM Shortcut name
SET LinkName=Spacer_%datetime%
REM Shortcut icon
SET LinkIcon=%startDirectory%transparent.ico
REM Create the shortcut on the Desktop
SET Esc_LinkDest=%%HOMEDRIVE%%%%HOMEPATH%%\Desktop\!LinkName!.lnk
REM Point to an executable that will perform nothing without parameters
SET Esc_LinkTarget=%%SYSTEMROOT%%\System32\rundll32.exe

REM File for the VB script
SET cSctVBS=CreateShortcut.vbs
REM File for the VB script logs
SET LOG=".\%~N0_runtime.log"

REM Generate the VB code to create the shortcut
REM See https://ss64.com/vb/shortcut.html
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!Esc_LinkDest!"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
  echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("!Esc_LinkTarget!"^)
  echo oLink.Arguments = "!LinkName!"
  echo oLink.IconLocation = "!LinkIcon!"
  echo oLink.Save
)1>!cSctVBS!

REM Execute the VB script
cscript //nologo .\!cSctVBS!
REM Delete the VB script
DEL !cSctVBS! /f /q
REM Log everything
)1>>!LOG! 2>>&1

ECHO The shortcut was created on the Desktop
ECHO Next steps:
ECHO - Pin the shortcut to the taskbar
ECHO - Delete the shortcut

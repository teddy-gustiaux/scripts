@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

REM Get script directory
SET startDirectory=%~dp0
REM Adobe Acrobat browser extension directory
SET extensionDirectory="C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Browser"

REM Ask user confirmation
ECHO This will delete all the content in %extensionDirectory%.
SET /P answer="Do you want to continue (Y/n)? "
IF /i {!answer!}=={n} (GOTO :END)
IF /i {!answer!}=={no} (GOTO :END)

:PROCESS

ECHO ^=^=^> Moving to Adobe Acrobat browser extension directory
cd /d %extensionDirectory%

ECHO ^=^=^> Deleting all files and folders
FOR /F "delims=" %%i IN ('dir /b') DO (
	rmdir "%%i" /S || del "%%i" /S /F
)

ECHO ^=^=^> Done^^!

:END
cd %startDirectory%
ENDLOCAL

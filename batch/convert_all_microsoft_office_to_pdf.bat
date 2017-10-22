@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

REM Check that the script can run
SET scriptDirectory=%~dp0
SET script="%scriptDirectory%convert_microsoft_office_to_pdf"
IF NOT EXIST "%script%.vbs" (
    ECHO [ERROR] VBScript for conversion not found
    GOTO :EOF
) ELSE (
    SET vbs="%script%.vbs"
)

REM Get number of documents
SET count=0
FOR %%x in (*.doc,*.docx,*.ppt,*.pptx) DO SET /a count+=1

IF %count% EQU 0 (
    ECHO [ERROR] No documents found in current folder
    GOTO :EOF
)

SET number=1
FOR %%f IN (*.doc,*.docx,*.ppt,*.pptx) DO (
    ECHO [WORK] Converting "%%f" (!number!/%count%^)
    cscript //B "%vbs%" "%%~dpnxf"
    SET /a number+=1
)

ECHO [INFO] All operations are completed

:EOF
ENDLOCAL
@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

REM Check that the script can run
SET scriptDirectory=%~dp0
SET script=%scriptDirectory%%~n0
IF NOT EXIST "%script%.vbs" (
    ECHO [ERROR] VBScript for conversion not found
    GOTO :EOF
) ELSE (
    SET vbs="%script%.vbs"
)

IF "%1" == "" (
    ECHO [ERROR] No file provided
    GOTO :EOF
) ELSE (
    SET name=%1
)

ECHO [WORK] Converting "%name%"
cscript //B "%vbs%" "%name%"

ECHO [INFO] All operations are completed

:EOF
ENDLOCAL
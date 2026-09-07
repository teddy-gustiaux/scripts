@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

ECHO [NOTE] This script only process pictures in current folder

SET LF=^


REM Two empty lines are required!

REM Get number of pictures
SET count=0
FOR %%x in (*.jpg *.jpeg *.png) DO SET /a count+=1

REM Get script directory
SET startDirectory=%~dp0

REM Check that the script can run
IF NOT EXIST "exiftool.exe" (
	IF NOT EXIST "C:\ProgramData\Chocolatey\bin\exiftool.exe" (
		IF NOT EXIST "%startDirectory%Apps\exiftool\exiftool.exe" (
			ECHO [ERROR] ExifTool not found
			GOTO :EOF
		) ELSE (
			SET exif="%startDirectory%Apps\exiftool\exiftool.exe"
		)
	) ELSE (
		SET exif="C:\ProgramData\Chocolatey\bin\exiftool.exe"
	)
) ELSE (
    SET exif="exiftool.exe"
)

IF %count% EQU 0 (
    ECHO [ERROR] No pictures found in current folder
    GOTO :EOF
)


SET number=1
SET wrong=0
FOR %%x in (*.jpg *.jpeg *.png) DO (
    ECHO [WORK] Checking "%%x" (!number!/%count%^)
    REM Get the date at which the picture has been taken
    SET datetime=
    FOR /f %%i in ('CALL %exif% -d "%%Y-%%m-%%d" -DateTimeOriginal -S -s "%%x"') DO SET datetime=%%i
    IF [!datetime!] == [] (
        SET /a wrong+=1
		ECHO [MISSING] "%%x" does not have a datetime
    )
    SET /a number+=1
)
ECHO [INFO] %wrong% picture(s) do not have a datetime

:END

ECHO [INFO] All operations are completed
ENDLOCAL
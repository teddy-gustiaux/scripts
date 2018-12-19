@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

ECHO [NOTE] This script only process pictures in current folder

SET LF=^


REM Two empty lines are required!

REM Get number of pictures
SET count=0
FOR %%x in (*.jpg) DO SET /a count+=1

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

IF "%1" == "" (

    ECHO No name provided
	SET /P answer="Do you want to enter a name (Y/n)? "
    IF /I {!answer!}=={n} (GOTO :NONAME)
    IF /I {!answer!}=={no} (GOTO :NONAME)
	
	SET /P name="Enter your name: "
	GOTO :CHECK
	
	:NONAME
    SET /P answer="Do you want to continue (Y/n)? "
    IF /I {!answer!}=={n} (GOTO :NO)
    IF /I {!answer!}=={no} (GOTO :NO)

    ECHO [INFO] Not using a name
    SET name=
    GOTO :CHECK

    :NO
    ECHO [ERROR] Operation aborted
    GOTO :EOF

) ELSE (

    SET name=%1

)

:CHECK

SET /P answer="Do you want to check the pictures have a datetime (Y/n)? "
IF /i {!answer!}=={n} (GOTO :PROCESS)
IF /i {!answer!}=={no} (GOTO :PROCESS)

SET number=1
SET wrong=0
FOR %%x in (*.jpg) DO (
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

SET /P answer="Do you want to continue (Y/n)? "
IF /i {!answer!}=={n} (GOTO :END)
IF /i {!answer!}=={no} (GOTO :END)

:PROCESS

REM Get first argument fully qualified path name
SET file=%~f1

SET /P answer="Do you want to sort the pictures by datetime taken (Y/n)? "
IF /i {!answer!}=={n} (GOTO :NOSORTING)
IF /i {!answer!}=={no} (GOTO :NOSORTING)

ECHO [INFO] Sorting pictures
CALL %exif% "-FileName<DateTimeOriginal" -d "%%%%Y-%%%%m-%%%%d_%%%%H.%%%%M.%%%%S%%%%%%%%-c.%%%%%%%%e" .

:NOSORTING

IF NOT [%name%] == [] (

    SET /P answer="Do you want to rename pictures (Y/n)? "
    IF /i {!answer!}=={n} (GOTO :METADATA)
    IF /i {!answer!}=={no} (GOTO :METADATA)

	SET includetime=1
	SET /P answer="Do you want to include time taken on top of the date (Y/n)? "
    IF /i {!answer!}=={n} (SET includetime=0)
    IF /i {!answer!}=={no} (SET includetime=0)
	
    SET number=1
    FOR %%x in (*.jpg) DO (
        REM Get the date at which the picture has been taken
		IF !includetime! EQU 1 (
			FOR /f %%i in ('CALL %exif% -d "%%Y-%%m-%%d-%%H.%%M.%%S" -DateTimeOriginal -S -s "%%x"') DO SET datetime=%%i
		) ELSE (
			FOR /f %%i in ('CALL %exif% -d "%%Y-%%m-%%d" -DateTimeOriginal -S -s "%%x"') DO SET datetime=%%i
		)
        REM Get the picture number
        SET formattedValue=00!number!
        IF %count% GTR 99 (
            REM More than 99 pictures
            SET formattedValue=!formattedValue:~-3!
        ) ELSE (
            REM Less than 100 pictures
            SET formattedValue=!formattedValue:~-2!
        )
        REM Get extension
        FOR /f "delims=" %%a in ("%%x") DO SET "extension=%%~xa"
        REM Rename picture
        SET newName=!datetime!-%name%-!formattedValue!!extension!
        ECHO [WORK] Renaming "%%x" to "!newName!" (!number!/%count%^)
        RENAME "%%x" "!newName!"
        REM Increment picture number
        SET /a number+=1
    )
)

:METADATA

SET /P answer="Do you want to remove pictures metadata (Y/n)? "
IF /i {!answer!}=={n} (GOTO :SORTING)
IF /i {!answer!}=={no} (GOTO :SORTING)

SET number=1
FOR %%x in (*.jpg) DO (
    ECHO [WORK] Clearing "%%x" (!number!/%count%^)
    COPY "%%x" "%%x-PROCESSING" >NUL
    CALL %exif% -P -all= -all:all= -XMP:All= -IPTC:Keywords= -ThumbnailImage= -overwrite_original "%%x" >NUL
    CALL %exif% -overwrite_original -P -tagsFromFile "%%x-PROCESSING" -DateTimeOriginal "%%x" -Orientation "%%x" >NUL
    DEL "%%x-PROCESSING" >NUL
    SET /a number+=1
)

:SORTING

SET question=Do you want to sort pictures by!LF!- YYYY/MM/DD/Name (1)!LF!- YYYY/MM/DD (2)!LF!- MM/DD (3)!LF!- DD only (4)!LF!- Not sorting them (n)?
ECHO !question!
SET /P answer="Select your option: "
IF /i !answer! EQU 1 (GOTO :CUSTOM)
IF /i !answer! EQU 2 (GOTO :YEARS)
IF /i !answer! EQU 3 (GOTO :MONTHS)
IF /i !answer! EQU 4 (GOTO :DAYS)
IF /i {!answer!}=={n} (GOTO :END)
IF /i {!answer!}=={no} (GOTO :END)

:CUSTOM

CALL %exif% "-Directory<DateTimeOriginal" -d "%%%%Y/%%%%m/%%%%d/%name%" .
GOTO :END

:YEARS

CALL %exif% "-Directory<DateTimeOriginal" -d "%%%%Y/%%%%m/%%%%d" .
GOTO :END

:MONTHS

CALL %exif% "-Directory<DateTimeOriginal" -d "%%%%m/%%%%d" .
GOTO :END

:DAYS

CALL %exif% "-Directory<DateTimeOriginal" -d "%%%%d" .
GOTO :END

:END

ECHO [INFO] All operations are completed
ENDLOCAL
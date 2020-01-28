@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

SET counter=0

FOR %%x IN (*.mkv,*.mp4) DO (
    ECHO [WORK] Testing "%%x"
    ffprobe "%%x" > nul 2>&1
    IF errorlevel 1 (
        SET listOfCorruptedFiles[!counter!]="%%x"
        SET /A counter=counter+1
    )
)

ECHO [INFO] Found %counter% corrupted files
IF !counter! gtr 0 FOR /F "tokens=2 delims==" %%s IN ('SET listOfCorruptedFiles[') DO ECHO [CORRUPTED] %%s

ECHO [INFO] All operations are completed
ENDLOCAL
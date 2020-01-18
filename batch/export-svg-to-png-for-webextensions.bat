@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

SET svgFile=%1

FOR %%x in (16 24 32 48 64 96 128 256 512 1024) DO (
    ECHO [WORK] Exporting to "%%xpx"
    inkscape --export-png "%svgFile:~0,-4%-%%x.png" -w "%%x" "%svgFile%"
)

ECHO [INFO] All operations are completed
ENDLOCAL
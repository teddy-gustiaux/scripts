@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

SET timeToWait=%1
IF [%timeToWait%] == [] SET timeToWait=20

ECHO [INFO] This system will be suspended in %timeToWait% seconds
timeout /t %timeToWait% /nobreak
rundll32.exe powrprof.dll,SetSuspendState 0,1,0
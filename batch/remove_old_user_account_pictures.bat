@ECHO OFF
SETLOCAL
SETLOCAL EnableExtensions EnableDelayedExpansion

SET /P name="Enter your Windows username: "
ECHO You have entered [%name%]

SET /P answer="Do you want to continue (Y/n)? "
IF /I {!answer!}=={n} (GOTO :EOF)
IF /I {!answer!}=={no} (GOTO :EOF)

DEL "C:\Users\%name%\AppData\Roaming\Microsoft\Windows\AccountPictures\*.accountpicture-ms"

ECHO All old user accounts pictures have been deleted
ENDLOCAL
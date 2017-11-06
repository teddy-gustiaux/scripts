:: Created by: Shawn Brink
:: Created on: April 27th 2015
:: Tutorial: http://www.tenforums.com/tutorials/5645-icon-cache-rebuild-windows-10-a.html


@echo off
set iconcache=%localappdata%\IconCache.db

echo.
echo The explorer process must be temporarily killed before deleting the IconCache.db file. 
echo.
echo Please SAVE ALL OPEN WORK before continuing.
echo.
pause
echo.
If exist "%iconcache%" goto delete
echo.
echo The IconCache.db file has already been deleted. 
goto restart


:delete
echo.
echo Attempting to delete IconCache.db files...
echo.
ie4uinit.exe -show
taskkill /IM explorer.exe /F 
del /A /Q "%iconcache%"
del /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*"
start explorer.exe
echo.
echo IconCache.db files have been successfully deleted.
goto restart


:restart
echo.
echo.
echo You will need to restart the PC to finish rebuilding your icon cache.
echo.
CHOICE /C:YN /M "Do you want to restart the PC now?"
IF ERRORLEVEL 2 goto no
IF ERRORLEVEL 1 goto yes

:yes
shutdown /r /f /t 00

:no
exit /B
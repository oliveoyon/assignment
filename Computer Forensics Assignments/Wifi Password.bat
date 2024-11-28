@echo off
:: Enable delayed expansion for dynamic variable usage
setlocal enabledelayedexpansion

:start
cls
echo =================================================
echo           Dynamic Wi-Fi Profile Viewer
echo =================================================
echo.
echo Scanning for saved Wi-Fi profiles...
echo.

:: Initialize counter and list Wi-Fi profiles
set count=0
for /f "tokens=1,2 delims=:" %%i in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    set /a count+=1
    set profile[!count!]=%%j
    echo !count!. %%j
)
echo.
echo Select a profile number to view details or type 0 to exit:
set /p choice="Enter your choice: "

:: Handle exit
if "%choice%"=="0" (
    echo Exiting...
    exit /b
)

:: Validate input
if not defined profile[%choice%] (
    echo Invalid choice. Please try again.
    pause
    goto start
)

:: Display selected profile details
set selectedProfile=!profile[%choice%]:~1!
cls
echo =================================================
echo         Details for Wi-Fi Profile: %selectedProfile%
echo =================================================
netsh wlan show profile name="%selectedProfile%" key=clear
echo.
echo Press any key to go back to the list...
pause
goto start

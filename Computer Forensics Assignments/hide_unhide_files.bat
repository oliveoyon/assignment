@echo off
setlocal

:: Check if the user passed parameters
if "%1"=="" goto usage

:: Set the operation (hide/unhide) and the target folder/file
set operation=%1
set target=%2

:: Check if the target exists
if not exist "%target%" (
    echo The specified path does not exist: %target%
    goto end
)

:: Check for valid operation
if "%operation%"=="hide" goto hide
if "%operation%"=="unhide" goto unhide

:: If neither "hide" nor "unhide" is passed
goto usage

:: Hide the target folder/file
:hide
echo Hiding: %target%
attrib +h +s "%target%"
if exist "%target%" (
    echo Folder/File has been hidden.
) else (
    echo Error hiding the folder/file.
)
goto end

:: Unhide the target folder/file
:unhide
echo Unhiding: %target%
attrib -h -s "%target%"
if exist "%target%" (
    echo Folder/File has been unhidden.
) else (
    echo Error unhiding the folder/file.
)
goto end

:: Show usage instructions
:usage
echo Usage: hide_unhide_files.bat [hide|unhide] [file_or_folder_path]
echo Example: hide_unhide_files.bat hide "C:\Users\User\Desktop\Test"
goto end

:: End the script
:end
endlocal
pause

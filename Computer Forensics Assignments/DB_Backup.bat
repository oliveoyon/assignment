@echo off
:: Set variables
set "db_name=college"
set "db_user=root"
set "db_pass="
set "backup_dir=D:\BackupDB"
set "timestamp=%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"

:: Create backup directory if it doesn't exist
if not exist "%backup_dir%" (
    mkdir "%backup_dir%"
)

:: Path to MySQL dump utility (adjust if WAMP is installed in a custom directory)
set "mysqldump_path=D:\wamp64\bin\mysql\mysql9.1.0\bin\mysqldump.exe"

:: Backup file name
set "backup_file=%backup_dir%\%db_name%_backup_%timestamp%.sql"

:: Perform the backup
"%mysqldump_path%" -u %db_user% -p%db_pass% %db_name% > "%backup_file%"

:: Check if the backup was successful
if exist "%backup_file%" (
    echo Backup successful: %backup_file%
) else (
    echo Backup failed.
)

:: Pause for confirmation
pause

# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
# Press A for All
# This file is used for real-time monitoring of file creation/deletion/modification

# Define the directory to monitor
$directoryToWatch = "D:\Computer Forensics Assignments"

# Define the log file path (Ensure this includes a file name)
$logFilePath = "D:\MonitorLog.txt"

# Ensure the log file directory exists
$logDirectory = Split-Path -Path $logFilePath
if (!(Test-Path -Path $logDirectory)) {
    Write-Host "Directory doesn't exist, creating directory: $logDirectory"
    New-Item -ItemType Directory -Path $logDirectory | Out-Null
}

# Check if log file exists, if not, create it
if (!(Test-Path -Path $logFilePath)) {
    Write-Host "Log file doesn't exist, creating file: $logFilePath"
    New-Item -ItemType File -Path $logFilePath | Out-Null
}

# Create a FileSystemWatcher object
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $directoryToWatch
$watcher.IncludeSubdirectories = $true  # Set to $true to monitor subdirectories
$watcher.EnableRaisingEvents = $true   # Start watching the directory

# Define actions for events
$action = {
    $eventType = $Event.SourceEventArgs.ChangeType
    $fileName = $Event.SourceEventArgs.Name
    $fullPath = $Event.SourceEventArgs.FullPath
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$time - $eventType detected on $fullPath"
    
    # Write to console
    Write-Host $logEntry

    # Debug: Check if the log file path is valid
    Write-Host "Log file path: $logFilePath"
    if ($null -eq $logFilePath) {
        Write-Host "Error: Log file path is null!"
    }

    # Try appending to the log file and check for errors
    try {
        Add-Content -Path $logFilePath -Value $logEntry
    } catch {
        Write-Host "Error writing to log file: $_"
    }
}

# Register event handlers
Register-ObjectEvent $watcher Created -Action $action
Register-ObjectEvent $watcher Changed -Action $action
Register-ObjectEvent $watcher Deleted -Action $action
Register-ObjectEvent $watcher Renamed -Action {
    $oldName = $Event.SourceEventArgs.OldFullPath
    $newName = $Event.SourceEventArgs.FullPath
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$time - File renamed from $oldName to $newName"
    
    # Write to console
    Write-Host $logEntry

    # Debug: Check if the log file path is valid
    Write-Host "Log file path: $logFilePath"
    if ($null -eq $logFilePath) {
        Write-Host "Error: Log file path is null!"
    }

    # Try appending to the log file and check for errors
    try {
        Add-Content -Path $logFilePath -Value $logEntry
    } catch {
        Write-Host "Error writing to log file: $_"
    }
}

# Keep the script running
Write-Host "Monitoring directory: $directoryToWatch. Press Ctrl+C to exit."
while ($true) { Start-Sleep -Seconds 1 }

# Define the log file path
$logFilePath = "C:\Users\User\Desktop\USBDeviceLog.txt"

# Ensure the log file exists
if (!(Test-Path -Path $logFilePath)) {
    New-Item -ItemType File -Path $logFilePath | Out-Null
}

# Function to log USB device details
function Log-USBDeviceDetails {
    param (
        [string]$Action,
        [string]$DeviceName,
        [string]$EventTime
    )

    # Log entry format
    $logEntry = "$EventTime - $Action - Device Name: $DeviceName"
    Write-Host $logEntry

    # Append the log entry to the file
    Add-Content -Path $logFilePath -Value $logEntry
}

# Monitor USB device insertion events
Register-WmiEvent -Query "SELECT * FROM __InstanceCreationEvent WITHIN 2 WHERE TargetInstance ISA 'Win32_USBControllerDevice'" -Action {
    # Get the device instance
    $deviceInstance = $Event.SourceEventArgs.NewEvent.TargetInstance.Dependent
    $deviceDetails = Get-WmiObject -Query "SELECT * FROM Win32_PnPEntity WHERE DeviceID='$deviceInstance'" | Select-Object Name

    # Extract details for logging
    $deviceName = $deviceDetails.Name
    $eventTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Log the event
    Log-USBDeviceDetails -Action "Inserted" -DeviceName $deviceName -EventTime $eventTime
}

Write-Host "USB device tracking started. Press Ctrl+C to exit."
while ($true) { Start-Sleep -Seconds 1 }

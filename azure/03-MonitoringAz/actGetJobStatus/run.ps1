# Accepts a single parameter, which is the URL of the process to check
param($processurl)

# Makes a GET request to the provided URL, converts the JSON response to a PowerShell object,
# and extracts the 'runtimeStatus' property
$status= (Invoke-WebRequest -Uri $processurl -Method Get | ConvertFrom-Json).runtimeStatus

# Returns the status
$status
# Define a parameter for the URL of the process
param($processurl)

# Send a GET request to the process URL and convert the response from JSON
# Extract the 'runtimeStatus' from the response
$status= (Invoke-WebRequest -Uri $processurl -Method Get | ConvertFrom-Json).runtimeStatus

# Output the status
$status
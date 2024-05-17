# Define a parameter for the context
param($Context)

# Initialize an empty array for output
$output = @()

# Extract values from the context input
$processUrl=$Context.Input.ProcessUrl.Value
$TeamsChannelId = $Context.Input.TeamsChannelId.Value
$pollingInterval = New-TimeSpan -Seconds $Context.Input.PollingInterval.Value
$expiryTime = $Context.Input.ExpiryTime.Value

# Loop until the current time is less than the expiry time
while ($Context.CurrentUtcDateTime -lt $expiryTime) {
    # Get the job status by invoking the 'actGetJobStatus' function
    $jobStatus = Invoke-DurableActivity -FunctionName 'actGetJobStatus' -Input $processUrl
    Write-Host "MonitorOrchestrator: Current job status is '$jobStatus'."
    
    # If the job status is "Completed", send an alert and break the loop
    if ($jobStatus -eq "Completed") {
        $output += Invoke-DurableActivity -FunctionName 'actSendAlert' -Input $TeamsChannelId
        break
    }

    # Sleep for the duration of the polling interval
    Start-DurableTimer -Duration $pollingInterval
}

# Print a message indicating that the orchestrator has finished
Write-Host 'MonitorOrchestrator: finished.'

# Return the output
$output
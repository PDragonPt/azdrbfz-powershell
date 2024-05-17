# Accepts a single parameter, the context of the current orchestration
param($Context)

# Initializes an array to hold the output
$output = @()

# Retrieves the process URL, Teams channel ID, polling interval, and expiry time from the context
$processUrl=$Context.Input.ProcessUrl.Value
$TeamsChannelId = $Context.Input.TeamsChannelId.Value
$pollingInterval = New-TimeSpan -Seconds $Context.Input.PollingInterval.Value
$expiryTime = $Context.Input.ExpiryTime.Value

# Continues to poll the job status until the current time is greater than the expiry time
while ($Context.CurrentUtcDateTime -lt $expiryTime) {
    # Retrieves the job status
    $jobStatus = Invoke-DurableActivity -FunctionName 'actGetJobStatus' -Input $processUrl
    Write-Host "MonitorOrchestrator: Current job status is '$jobStatus'."
    
    # If the job status is "Completed", sends an alert and breaks the loop
    if ($jobStatus -eq "Completed") {
        $output += Invoke-DurableActivity -FunctionName 'actSendAlert' -Input $TeamsChannelId
        break
    }

    # Waits for the specified polling interval before checking the job status again
    Start-DurableTimer -Duration $pollingInterval
}

# Outputs a message indicating that the orchestration has finished
Write-Host 'MonitorOrchestrator: finished.'

# Returns the output
$output
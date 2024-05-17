# Import the System.Net namespace
using namespace System.Net

# Define parameters for the script
param($Request, $TriggerMetadata)

# Print a message indicating the start of the external process execution
Write-Host 'Execute external Process Start(just for this demo!)'

# Invoke the external process
$url="http://localhost:7071/api/orchestrators/processes/orchProcess?hero=Wolverine"
# Send a GET request to the URL and extract the statusQueryGetUri property from the response
$processUrl= (Invoke-WebRequest -Uri $url -Method Get | ConvertFrom-Json).statusQueryGetUri

# Print a message indicating the end of the external process execution
Write-Host 'Execute external Process End'

# Print a message indicating the start of the MonitorStart function
Write-Host 'MonitorStart started'

# Define the inputs for the orchestrator function
$OrchestratorInputs = @{ 
    ProcessUrl = $processUrl;
    TeamsChannelId = $env:AppTeamsWebHookUrl;
    PollingInterval = 10;
    ExpiryTime = (Get-Date).ToUniversalTime().AddSeconds(60) 
}

# Start the orchestrator function and get the instance ID
$InstanceId = Start-DurableOrchestration -FunctionName 'orchMonitor' -InputObject $OrchestratorInputs

# Print the instance ID
Write-Host "Started orchestration with ID = '$InstanceId'"

# Create a response object that includes the status of the orchestrator function
$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId

# Add the response object to the output bindings of the function
Push-OutputBinding -Name Response -Value $Response

# Print a message indicating the completion of the MonitorStart function
Write-Host 'MonitorStart completed'
# Import the System.Net namespace for network operations
using namespace System.Net

# Define parameters for the script: the HTTP request and trigger metadata
param($Request, $TriggerMetadata)

# Log the start of the external process execution
Write-Host 'Execute external Process Start(just for this demo!)'

# Invoke the external process by sending a GET request to the specified URL
# The response is converted from JSON and the statusQueryGetUri property is extracted
$url="http://localhost:7071/api/orchestrators/processes/orchProcess?hero=Wolverine"
$processUrl= (Invoke-WebRequest -Uri $url -Method Get | ConvertFrom-Json).statusQueryGetUri

# Log the end of the external process execution
Write-Host 'Execute external Process End'

# Log the start of the monitoring process
Write-Host 'MonitorStart started'

# Define the inputs for the orchestrator function
# These include the process URL, Teams channel ID, polling interval, and expiry time
$OrchestratorInputs = @{ ProcessUrl = $processUrl;TeamsChannelId = $env:AppTeamsWebHookUrl;PollingInterval = 10;ExpiryTime = (Get-Date).ToUniversalTime().AddSeconds(60) }

# Start the orchestrator function with the defined inputs
# The function name is 'orchMonitor' and the instance ID is stored for later use
$InstanceId = Start-DurableOrchestration -FunctionName 'orchMonitor' -InputObject $OrchestratorInputs

# Log the instance ID of the started orchestration
Write-Host "Started orchestration with ID = '$InstanceId'"

# Create a response that includes the status of the durable orchestration
# This response can be used to check the status of the orchestration at a later time
$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId

# Push the response to the output binding
Push-OutputBinding -Name Response -Value $Response

# Log the completion of the monitoring process
Write-Host 'MonitorStart completed'
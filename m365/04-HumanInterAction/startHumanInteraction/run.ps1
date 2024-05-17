# Import the System.Net namespace
using namespace System.Net

# Define parameters for the script
param($Request, $TriggerMetadata)

# Get the instance ID from the request body
$InstanceId = $Request.Body.InstanceId

# Log the start of the script
Write-Host 'HumanInteractionStart started'

# Define the inputs for the orchestrator
$OrchestratorInputs = @{ Duration = 45; ManagerId = 1; SkipManagerId = 2 }

# Set the instance ID to "manualApproval"
$InstanceId = "manualApproval"

# Create a new URI object from the request URL
$uri = New-Object System.Uri($Request.Url)

# Build the base URL from the URI object
$baseURL = $uri.Scheme + "://" + $uri.Host + ":" + $uri.Port + $uri.AbsolutePath

# Remove the "/api/.*" part from the base URL
$baseURL = $baseURL -replace "/api/.*", ""

# Set the functions URL to the base URL
$FunctionsURL = $baseURL

# Get the status of the durable function
$Status = Get-DurableStatus -FunctionsUrl $FunctionsURL -InstanceId $InstanceId
    
# If the function is already running, log a message and exit the script
if ($Status.Length -gt 0 -and $Status[0].runtimeStatus -eq 'Running') {
    Write-Host 'HumanInteraction[$InstanceId] is already running'
    exit
}

# Start the durable orchestration
Start-DurableOrchestration -FunctionName 'orchHumanInteraction' -InputObject $OrchestratorInputs -InstanceId $InstanceId

# Log the start of the orchestration
Write-Host "Started orchestration with ID = '$InstanceId'"

# Create a new check status response
$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId

# Push the response to the output binding
Push-OutputBinding -Name Response -Value $Response

# Log the completion of the script
Write-Host 'HumanInteractionStart completed'
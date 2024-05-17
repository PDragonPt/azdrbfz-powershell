# Import the System.Net namespace for network operations
using namespace System.Net

# Define parameters for the script: a request object and trigger metadata
param($Request, $TriggerMetadata)

# Retrieve the function name from the request parameters
$FunctionName = $Request.Params.FunctionName

# Start a durable orchestration with the specified function name
# Store the instance ID of the orchestration in the 'InstanceId' variable
$InstanceId = Start-DurableOrchestration -FunctionName $FunctionName

# Output a message to the console indicating the orchestration has started, along with its instance ID
Write-Host "Started orchestration with ID = '$InstanceId'"

# Create a new durable orchestration check status response with the request and instance ID
# Store the response in the 'Response' variable
$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId

# Push the response to the output binding named 'Response'
Push-OutputBinding -Name Response -Value $Response
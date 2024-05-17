# Import the System.Net namespace for network operations
using namespace System.Net

# Define parameters for the script: the HTTP request and trigger metadata
param($Request, $TriggerMetadata)

# Retrieve the function name from the request parameters
$FunctionName = $Request.Params.FunctionName

# Start the durable orchestration with the specified function name
# The query parameters from the request are passed as input to the orchestration
# The instance ID of the started orchestration is stored for later use
$InstanceId = Start-DurableOrchestration -FunctionName $FunctionName -InputObject $Request.Query

# Log the instance ID of the started orchestration
Write-Host "Started orchestration with ID = '$InstanceId'"

# Create a response that includes the status of the durable orchestration
# This response can be used to check the status of the orchestration at a later time
$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId

# Push the response to the output binding
Push-OutputBinding -Name Response -Value $Response
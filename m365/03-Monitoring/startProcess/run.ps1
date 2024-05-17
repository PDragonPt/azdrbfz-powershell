# Import the System.Net namespace
using namespace System.Net

# Define parameters for the script
param($Request, $TriggerMetadata)

# Extract the function name from the request parameters
$FunctionName = $Request.Params.FunctionName

# Start the orchestrator function with the given function name and input object, and get the instance ID
$InstanceId = Start-DurableOrchestration -FunctionName $FunctionName -InputObject $Request.Query

# Print the instance ID
Write-Host "Started orchestration with ID = '$InstanceId'"

# Create a response object that includes the status of the orchestrator function
$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId

# Add the response object to the output bindings of the function
Push-OutputBinding -Name Response -Value $Response
# Import the System.Net namespace
using namespace System.Net

# Define parameters for the script
param($Request, $TriggerMetadata)

# Extract the function name from the request parameters
$FunctionName = $Request.Params.FunctionName

# Start a durable orchestration with the function name and request query as input
# Store the instance ID of the orchestration
$InstanceId = Start-DurableOrchestration -FunctionName $FunctionName -InputObject $Request.Query

# Output the instance ID of the started orchestration
Write-Host "Started orchestration with ID = '$InstanceId'"

# Create a new durable orchestration check status response with the request and instance ID
# Store the response
$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId

# Push the response to the output binding named 'Response'
Push-OutputBinding -Name Response -Value $Response
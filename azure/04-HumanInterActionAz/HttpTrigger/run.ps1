# Import the System.Net namespace
using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$action = $Request.Query.Action
$InstanceId=$Request.Query.InstanceId

# Set instance ID from the trigger metadata
$InstanceId = $TriggerMetadata.InstanceId

# Set durable function information for custom Send-DurableExternalEvent
# Create a new URI object from the request URL
$uri = New-Object System.Uri($Request.Url)

# Build the base URL from the URI object
$baseURL = $uri.Scheme + "://" + $uri.Host + ":" + $uri.Port + $uri.AbsolutePath

# Remove the "/api/.*" part from the base URL
$baseURL = $baseURL -replace "/api/.*", ""

# Set the functions URL to the base URL
$FunctionsURL = $baseURL

# Set the application code
$AppCode = "XXX"

# Set the approval event based on the action
$approvalEvent = "$($action)Event"

# Log the action
if ($action -eq "Approve") {
    Write-Host " We are approving the request($approvalEvent)"
}
if ($action -eq "Denied") {
    Write-Host " We are declining the request($approvalEvent)"
}

# Send the durable external event
Send-DurableExternalEvent -FunctionsURL $FunctionsURL -InstanceId $InstanceId -AppCode $AppCode $approvalEvent -EventDataJson "{}"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $action
})
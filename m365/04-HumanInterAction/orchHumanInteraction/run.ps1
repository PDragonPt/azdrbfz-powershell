# Import the System.Net namespace
using namespace System.Net

# Define parameters for the script
param($Context)

# Log the start of the script
Write-Host 'HumanInteractionOrchestrator: started.'

# Initialize an empty array for the output
$output = @()

# Create a new TimeSpan object for the duration
$duration = New-TimeSpan -Seconds $Context.Input.Duration

# Get the skip manager ID from the context input
$skipManagerId = $Context.Input.SkipManagerId

# Invoke the "actRequestApproval" activity function and add the result to the output
$output += Invoke-DurableActivity -FunctionName "actRequestApproval" -Input $Context

# Start a durable timer and an external event listener for the "ApproveEvent" and "DeniedEvent" events
$durableTimeoutEvent = Start-DurableTimer -Duration $duration -NoWait
$approveEvent = Start-DurableExternalEventListener -EventName "ApproveEvent" -NoWait
$deniedEvent = Start-DurableExternalEventListener -EventName "DeniedEvent" -NoWait

# Wait for any of the tasks to complete
$firstEvent = Wait-DurableTask -Task @($approveEvent,$deniedEvent,$durableTimeoutEvent) -Any

# If the "ApproveEvent" event was raised, stop the timer and invoke the "actProcessApproval" activity function with "APPROVED" as the input
if ($approveEvent -eq $firstEvent)  {
    Stop-DurableTimerTask -Task $durableTimeoutEvent
    $output += Invoke-DurableActivity -FunctionName "actProcessApproval" -Input "APPROVED"
}

# If the "DeniedEvent" event was raised, stop the timer and invoke the "actProcessApproval" activity function with "DECLINED" as the input
if ($deniedEvent -eq $firstEvent)  {
    Stop-DurableTimerTask -Task $durableTimeoutEvent
    $output += Invoke-DurableActivity -FunctionName "actProcessApproval" -Input "DECLINED"
}

# If the timer completed, invoke the "actEscalateApproval" activity function with the skip manager ID as the input
else {
    $output += Invoke-DurableActivity -FunctionName "actEscalateApproval" -Input $Context
}

# Log the end of the script
Write-Host 'HumanInteractionOrchestrator: finished.'

# Return the output
$output
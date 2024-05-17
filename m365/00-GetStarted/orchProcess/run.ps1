param($Context)

$output = @()

$output += Invoke-DurableActivity -FunctionName 'actHello' -Input 'Tokyo'
$output += Invoke-DurableActivity -FunctionName 'actHello' -Input 'Seattle'
$output += Invoke-DurableActivity -FunctionName 'actHello' -Input 'London'

$output

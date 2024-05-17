param($Context)

# Initialize an empty array for output
$output = @()

# Invoke the 'actWeather' function with 'London' as input and store the result in the 'weather' variable
$weather= Invoke-DurableActivity -FunctionName 'actWeather' -Input 'London' 

# Invoke the 'actCleanCurrencyList' function
Invoke-DurableActivity -FunctionName 'actCleanCurrencyList'  | Out-Null

# Invoke the 'actCurrency' function with 'EUR' as input and store the result in the 'currencyList' variable
$currencyList = Invoke-DurableActivity -FunctionName 'actGetCurrencyFromAPI' -Input 'EUR' 

# Invoke the 'actAddCurrencyToList' function with 'currencyList' as input
Invoke-DurableActivity -FunctionName 'actAddCurrencyToList' -Input $currencyList| Out-Null

# Invoke the 'actGetCurrencyFromList' function and store the result in the 'listElements' variable
$listElements=Invoke-DurableActivity -FunctionName 'actGetCurrencyFromList'

# Convert 'currencyList' to JSON and add it to the 'output' array
$output += ($listElements| ConvertTo-Json -Depth 10)

# Add a separator to the 'output' array
$output += "#################################################"

# Convert 'weather' to JSON and add it to the 'output' array
$output += ($weather| ConvertTo-Json -Depth 10)

# Return the 'output' array
$output
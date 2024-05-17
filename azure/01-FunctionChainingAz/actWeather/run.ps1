# Define a parameter for the script to accept a city name as a string
param([string]$city)
$city="London"
# Retrieve the weather API key from the environment variables
$apiKey = $Env:APP_WEATHER_API_KEY

# Format the weather API URL from the environment variables, replacing placeholders with the city name and API key
$apiUrl = $Env:APP_WEATHER_API_URL -f $city, $apiKey

# Make a GET request to the weather API URL
# Store the response in the 'response' variable
$response = Invoke-RestMethod -Uri $apiUrl -Method Get

# Output the response
$response
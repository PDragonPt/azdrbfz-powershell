# Accepts a single parameter, the name of the character to search for
param([string]$CharacterName)

# Retrieve API keys and URLs from environment variables
$apiKey = $env:APP_MARVEL_API_PUB_KEY
$pKey = $env:APP_MARVEL_API_PRV_KEY
$requestCharacterUrl= $env:APP_MARVEL_API_CHARACTER_URL
$requestComicUrl= $env:APP_MARVEL_API_COMIC_URL

# Parse the limit of heroes to retrieve from environment variable
$TotalLimit =  [int]::Parse($env:APP_HERO_LIMIT)

# Generate a timestamp for the API request
$ts = ((Get-Date).ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ssZ")

# Create an MD5 hash for the API request
$hashTmp = $ts + $pKey + $apiKey
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($hashTmp))).Replace("-", "").ToLower()

# Set headers for the API request
$headers = @{
    "Accept-Encoding" = "gzip"
}

# Make the web request to search for the character
$requestUrl = $requestCharacterUrl -f $CharacterName, $apiKey, $ts, $hash
$response = @(Invoke-RestMethod -Uri $requestUrl -Method Get -Headers $headers)

# Retrieve the ID of the first character found
$id = $response.data.results.id[0]

# Set the limit for the number of comics to retrieve
$limit = 100
if ($TotalLimit -lt $limit) {
    $limit = $TotalLimit
}

# Initialize an array to hold the results
$allResults = @()

# Make the web request to retrieve the comics for the character
$requestUrl = $requestComicUrl -f $id, $apiKey, $ts, $hash,$limit
$response = Invoke-RestMethod -Uri $requestUrl -Method Get -Headers $headers
$results = $response.data.results

# Log the number of comics retrieved
Write-Host "Getting data : $($limit) Total:$($results.Count)"

# Loop through the results and add them to the array
foreach ($result in $results) {
    $theHero = New-Object PSObject
    $theHero | Add-Member -MemberType NoteProperty -Name "Character" -Value $CharacterName
    $theHero | Add-Member -MemberType NoteProperty -Name "Url" -Value $result.thumbnail.Path
    $allResults += $theHero
}

# Uncomment the following line to filter out any results without an image
# $allResults = $allResults | Where-Object { $_ -notlike "*image_not_available*" } 

# Return the results
$allResults
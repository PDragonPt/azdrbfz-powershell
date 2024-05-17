# Define a parameter for the character name
param([string]$CharacterName)

# Retrieve API keys and URLs from environment variables
$apiKey = $env:APP_MARVEL_API_PUB_KEY
$pKey = $env:APP_MARVEL_API_PRV_KEY
$requestCharacterUrl= $env:APP_MARVEL_API_CHARACTER_URL
$requestComicUrl= $env:APP_MARVEL_API_COMIC_URL

# Parse the total limit from environment variable
$TotalLimit =  [int]::Parse($env:APP_HERO_LIMIT)

# Generate timestamp and hash for API request
$ts = ((Get-Date).ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ssZ")
$hashTmp = $ts + $pKey + $apiKey
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($hashTmp))).Replace("-", "").ToLower()

# Set headers for the web request
$headers = @{
    "Accept-Encoding" = "gzip"
}

# Make the web request to search for the character
$requestUrl = $requestCharacterUrl -f $CharacterName, $apiKey, $ts, $hash
$response = @(Invoke-RestMethod -Uri $requestUrl -Method Get -Headers $headers)

# Extract the character ID from the response
$id = $response.data.results.id[0] # First element

# Set the limit for the API request
$limit = 100
if ($TotalLimit -lt $limit) {
    $limit = $TotalLimit
}

# Make the web request to get the comics for the character
$allResults = @()
$requestUrl = $requestComicUrl -f $id, $apiKey, $ts, $hash,$limit
$response = Invoke-RestMethod -Uri $requestUrl -Method Get -Headers $headers
$results = $response.data.results

# Output the number of results
Write-Host "Getting data : $($limit) Total:$($results.Count)"

# Process each result and add it to the allResults array
foreach ($result in $results) {
    $theHero = New-Object PSObject
    $theHero | Add-Member -MemberType NoteProperty -Name "Character" -Value $CharacterName
    $theHero | Add-Member -MemberType NoteProperty -Name "Url" -Value $result.thumbnail.Path
    $allResults += $theHero
}

# Pause for 10 seconds
Write-Host "actListHeroesClunkyWay : Slepping 10 seconds ..."
Start-Sleep -Seconds 10

# Return the allResults array
$allResults
# Define a parameter for the script
param($inputObject)

# Check if the image path exists
if (Test-Path -Path "$imgPath") {
    # If it exists, remove it
    Remove-item  -Path "$imgPath" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
}

# Define the image path
$imgPath = $env:TEMP+ "\azdrfx\MarvelHeroes"

# Extract the character name from the input object
$CharacterName = $inputObject.Character

# Extract the URL from the input object
$result = $inputObject.Url

# Get the last element of the URL
$number = $result.split("/")[-1]

# Construct the URL for the image
$url = "$($result).jpg"

# Construct the hero name
$hero = "$($CharacterName)_$($number)"

# Construct the output path for the image
$output = "$imgPath\$CharacterName\$hero.jpg"

# Create a new directory for the character
New-Item -ItemType Directory -Force -Path "$imgPath\$CharacterName"  | Out-Null

# Download the image and save it to the output path
Invoke-WebRequest -Uri $url -OutFile $output

# Output the URL
Write-Host "actSaveHeroes url: $url"

# Return the output path
return "$output;"
# The script accepts a single parameter, which is an object containing the character's name and the URL of their image.
param($inputObject)

# If the image path already exists, it is deleted.
if (Test-Path -Path "$imgPath") {
    Remove-item  -Path "$imgPath" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
}

# The image path is set to a temporary directory.
$imgPath = $env:TEMP+ "\azdrfx\MarvelHeroes"

# The character's name and image URL are extracted from the input object.
$CharacterName = $inputObject.Character
$result = $inputObject.Url

# The last element of the URL (presumably the image file name) is extracted.
$number = $result.split("/")[-1]

# The URL of the image is constructed.
$url = "$($result).jpg"

# The name of the image file is constructed using the character's name and the image file name.
$hero = "$($CharacterName)_$($number)"
$output = "$imgPath\$CharacterName\$hero.jpg"

# A new directory is created for the character.
New-Item -ItemType Directory -Force -Path "$imgPath\$CharacterName"  | Out-Null

# The image is downloaded and saved to the new directory.
Invoke-WebRequest -Uri $url -OutFile $output

# The URL of the image is printed to the console.
Write-Host "actSaveHeroes url: $url"

# The path of the saved image is returned.
return "$output;"
param($inputObject)
# Output a message to the console indicating the start of the list cleaning process
Write-Host " Upload Hero Images - Start"
$imgPath = $env:TEMP + "\azdrfx\MarvelHeroes\$inputObject"
$DocLib = $Env:AppMarvelHeroesDocLib

# Output a message to the console indicating the site we're connecting to
Write-Host " Connect to Site - $($Env:AppSiteUrl)"

# Connect to the SharePoint Online site using the URL from the environment variable and Managed Identity
$conn = Connect-PnPOnline -Url $Env:AppSiteUrl -ManagedIdentity

## get all files in $imagePath local folder
$items = Get-ChildItem -Path $imgPath -File
# Loop through each item in the 'items' array
foreach ($item in $items) {
    Write-Host " Uploading $($item)"
    ## upload file to Document library using pnp.powerhsell
    Add-PnPFile -Path $item -Folder  $DocLib  -Values @{Modified="12/28/2023"} -Connection $conn |Out-Null
}
  


Write-Host " Upload Hero Images - End"

$items
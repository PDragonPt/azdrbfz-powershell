# Define a parameter for the script: the input object
param($inputObject)

# Log the start of the connection process to the site
Write-Host " Connect to Site - $($Env:AppSiteUrl)"

# Connect to the SharePoint Online site using the specified URL and Managed Identity
# The connection object is stored for later use
$connection = Connect-PnPOnline -Url $Env:AppSiteUrl -ManagedIdentity 

# Log the start of the process to get the currency list items
Write-Host " Get Currency List Items - Start"

# Retrieve the list items from the specified list in SharePoint Online
# The fields Title, Rate, Currency, Inverse, and Date are retrieved
# The connection object is passed to the Get-PnPListItem cmdlet
# The retrieved list items are stored in an array for later use
$itemsRaw= @(Get-PnPListItem -List $Env:AppCurrencyList -Fields Title,Rate,Currency,Inverse,Date -Connection $connection).FieldValues 

# Transform the raw list items into a more usable format
# Each item is transformed into a hashtable with the keys BaseName, Rate, Currency, Inverse, and Date
$items = $itemsRaw| ForEach-Object {@{BaseName=$_.Title; Rate=$_.Rate;Currency=$_.Currency;Inverse=$_.Inverse;Date=$_.Date} }

# Log the end of the process to get the currency list items
Write-Host " Get Currency List Items - End"

# Loop through each item in the items array
foreach ($item in $items) {
    # Log the title of the current item
    Write-Host "Title:$Currency"
}

# Return the items array
$items
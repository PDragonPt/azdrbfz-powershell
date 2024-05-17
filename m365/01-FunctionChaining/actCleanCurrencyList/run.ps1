# Define a parameter for the script to accept an input object
param($inputObject)

# Output a message to the console indicating the site we're connecting to
Write-Host " Connect to Site - $($Env:AppSiteUrl)"

# Connect to the SharePoint Online site using the URL from the environment variable and Managed Identity
$conn= Connect-PnPOnline -Url $Env:AppSiteUrl -ManagedIdentity

# Get all list items from the SharePoint list specified in the environment variable, only retrieving the ID field
# Store the result in the 'items' variable as an array
$items = @(Get-PnPListItem -List $Env:AppCurrencyList -Fields ID -Connection $conn).FieldValues

# Output a message to the console indicating the start of the list cleaning process
Write-Host " Clean Currency List - Start"

# Loop through each item in the 'items' array
foreach($item in $items){
  # Remove the current list item from the SharePoint list
  Remove-PnPListItem -List $Env:AppCurrencyList -Identity $item.ID -Force -Connection $conn 
}

# Output a message to the console indicating the end of the list cleaning process
Write-Host " Clean Currency List - End"

# Output "Clean List Done" to indicate the script has finished executing
"Clean List Done"
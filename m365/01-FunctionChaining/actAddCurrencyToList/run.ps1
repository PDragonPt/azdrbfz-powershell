# Define a parameter for the script to accept an array of currency values
param($currencyListValues)


# Output a message to the console indicating the site we're connecting to
Write-Host " Connect to Site - $($Env:AppSiteUrl)"

# Connect to the SharePoint Online site using the URL from the environment variable and Managed Identity
$conn= Connect-PnPOnline -Url $Env:AppSiteUrl -ManagedIdentity

# Output a message to the console indicating the start of the currency adding process
Write-Host "Adding Currency From API - Start"

# Loop through each currency in the provided list
foreach($currency in $currencyListValues){
    # Create a hashtable of values for the new list item
    $values = @{
        "Title" = $currency.BaseName;
        "Rate" = $currency.Rate; 
        "Currency" =  $currency.Currency; 
        "Inverse" = $currency.Inverse; 
        "Date" = $currency.Date
    }
    # Add a new item to the SharePoint list with the values from the hashtable
    $item=Add-PnPListItem -List $Env:AppCurrencyList -Values $values -Connection $conn
}

# Output a message to the console indicating the end of the currency adding process
Write-Host "Adding Currency From API - End"

# Output "Done" to indicate the script has finished executing
"Done"
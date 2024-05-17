# Define a parameter for the script to accept an array of currency values
param($currencyListValues)

# use this if you want to test the activity as a regular powershell script
<# $currencyListValues= @(
    @{
        BaseName = "USD";
        Rate = 1.0;
        Currency = "United States Dollar";
        Inverse = 1.0;
        Date = "2021-01-01";
    },
    @{
        BaseName = "EUR";
        Rate = 0.8;
        Currency = "Euro";
        Inverse = 1.25;
        Date = "2021-01-01";
    },
    @{
        BaseName = "GBP";
        Rate = 0.7;
        Currency = "British Pound";
        Inverse = 1.43;
        Date = "2021-01-01";
    }
    
)
#>
Connect-AzAccount -Identity
# Set the Azure context to the subscription where the storage account resides
Set-AzContext -Subscription $env:AppSubscriptionId | Out-Null

# Get a reference to the storage account
$storageAccount = Get-AzStorageAccount `
                            -ResourceGroupName $env:AppStorageRGName `
                            -Name $env:AppStorageAccountName

# Get a reference to the context of the storage account
$ctx = $storageAccount.Context
## Delete all rows in Azure Table
# Get the table reference
$table = (Get-AzStorageTable  -Name $Env:AppCurrencyList -Context $ctx).CloudTable

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

    # Add a new item to the Table with the values from the hashtable
    $rowKey= "$($currency.BaseName)_$($currency.Currency)"
    Add-AzTableRow -Table $table -PartitionKey "Currency" -RowKey $rowKey -Property $values | Out-Null
}

# Output a message to the console indicating the end of the currency adding process
Write-Host "Adding Currency From API - End"

# Output "Done" to indicate the script has finished executing
"Done"
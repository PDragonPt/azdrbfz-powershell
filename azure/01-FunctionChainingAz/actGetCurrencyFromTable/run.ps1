# Define a parameter for the script
param($inputObject)

# Start cleaning the currency table
Write-Host " Get all Records Currency Table - Start"

# Connect to Azure account using Managed Identity
Write-Host " Connect to Azure"
Connect-AzAccount -Identity

# Set the context to the specific subscription
Set-AzContext -Subscription $env:AppSubscriptionId | Out-Null

# Get the storage account details
$storageAccount = Get-AzStorageAccount `
                            -ResourceGroupName $env:AppStorageRGName `
                            -Name $env:AppStorageAccountName

# Get the context of the storage account
$ctx = $storageAccount.Context

# Get the table from the storage account
$table = (Get-AzStorageTable  -Name $Env:AppCurrencyTable -Context $ctx).CloudTable

# Get all the rows/entities from the table
$entities = Get-AzTableRow -Table $table

# End cleaning the currency table
Write-Host " Get all Records Currency Table - End"

$entities
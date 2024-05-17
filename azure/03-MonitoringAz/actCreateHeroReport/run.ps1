
# Define a parameter for the script
param($inputObject)

# #Write your own dbg expressions
# $inputObject=@{"Column"="TestTenant"}

# Output a message to the console indicating the start of the report creation
Write-Host " Create Hero Report - Start"

# Define the path and filename for the report
$reportPath = $env:TEMP + "\azdrfx\MarvelHeroes\report"
$reportFile = "$reportPath\HeroesReport.csv"

# Create the directory for the report if it doesn't exist
New-item -ItemType Directory -Path $reportPath -Force | Out-Null

# Export the input object to a CSV file
$inputObject | Export-Csv -Path $reportFile -NoTypeInformation

# Output a message to the console indicating the report has been generated
Write-Host " Report generated!"

# Connect to Azure with the current user's credentials
Connect-AzAccount -Identity

# Set the Azure context to the subscription where the storage account resides
Set-AzContext -Subscription $env:AppSubscriptionId | Out-Null

# Get a reference to the storage account
$storageAccount = Get-AzStorageAccount `
                            -ResourceGroupName $env:AppStorageRGName `
                            -Name $env:AppStorageAccountName

# Get a reference to the context of the storage account
$ctx = $storageAccount.Context

# Upload the report file to a blob in the storage account
Set-AzStorageBlobContent -File $reportFile -Container "reports" `
                    -Blob "HeroesReport.csv" -Context $ctx  -Force | Out-Null

# Output a message to the console indicating the report has been uploaded
Write-Host " Report uploaded to Azure Storage Account - $storageAccountName"

# Output a message to the console indicating the report has been uploaded
Write-Host "  Report uploaded"

# Output a message to the console indicating the end of the report creation
Write-Host " Create Hero Report - End"

# Return a message indicating the report has been uploaded
"Report uploaded to $DocLib"
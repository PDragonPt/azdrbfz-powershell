param($inputObject)
# Output a message to the console indicating the start of the list cleaning process
Write-Host " Upload Hero Images - Start"
$imgPath = $env:TEMP + "\azdrfx\MarvelHeroes\$inputObject"

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



## get all files in $imagePath local folder
$items = Get-ChildItem -Path $imgPath -File
# Loop through each item in the 'items' array
foreach ($item in $items) {
    Write-Host " Uploading $($item)"
   
    $file = Split-Path -Path $item -Leaf
    # Upload the report file to a blob in the storage account
    Set-AzStorageBlobContent -File $item -Container "images" `
    -Blob $file -Context $ctx  -Force | Out-Null
}
  


Write-Host " Upload Hero Images - End"

$items
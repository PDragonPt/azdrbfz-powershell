# Define a parameter for the script
param($inputObject)

# Split the input object by semicolon and filter out any empty strings
$allObjects = $inputObject.Split(";") | Where-Object {$_ -ne ""}

# Initialize a variable to hold the total size
$totalSize=0

# Loop through each URL in the allObjects array
foreach($url in $allObjects){
    # Output the current URL
    Write-Host "allObjects url: $url"
    
    # Get the file at the current URL
    $file=Get-Item -Path $url
    
    # Add the size of the current file to the total size
    $totalSize+= $file.Length
}

# Convert the total size to kilobytes
$totalSizeKb=$totalSize / 1kb

# Convert the total size to megabytes
$totalSizeMB= $totalSize / 1Mb

# Initialize the output string with the total size in kilobytes
$outPut="Total Size Kb: $totalSizeKb Kb`n"

# Append the total size in megabytes to the output string
$outPut+="Total Size Mb: $totalSizeMB MB`n"

# Append the total number of files to the output string
$outPut+="Total Files: $($allObjects.Count)"

# Output the final string
$outPut
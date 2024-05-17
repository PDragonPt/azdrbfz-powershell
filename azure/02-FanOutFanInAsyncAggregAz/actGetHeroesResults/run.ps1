# The script accepts a single parameter, which is a semicolon-separated string of file paths.
param($inputObject)

# The string is split into an array of file paths, and any empty strings are removed.
$allObjects = $inputObject.Split(";")| Where-Object {$_ -ne ""}

# A variable to hold the total size of all files is initialized to 0.
$totalSize=0

# The script then loops over each file path.
foreach($url in $allObjects){
    # The current file path is printed to the console.
    Write-Host "allObjects url: $url"
    
    # The file at the current path is retrieved, and its size is added to the total.
    $file=Get-Item -Path $url
    $totalSize+= $file.Length
}

# The total size is converted to kilobytes and megabytes.
$totalSizeKb=$totalSize / 1kb
$totalSizeMB= $totalSize / 1Mb

# A string is built up to display the total size in kilobytes and megabytes, and the total number of files.
$outPut="Total Size Kb: $totalSizeKb Kb`n"
$outPut+="Total Size Mb: $totalSizeMB MB`n"
$outPut+="Total Files: $($allObjects.Count)"

# The output string is returned.
$outPut
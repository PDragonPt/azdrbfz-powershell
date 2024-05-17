param($inputObject) # Define a parameter for the script

# $inputObject=@{"abc"="abc1"} # Uncomment this line to manually set the input object for debugging

$DocLib = $Env:AppReportDocLib # Get the document library from the environment variable

# Output a message to the console indicating the start
Write-Host " Create Hero Report - Start"

# Define the path and filename for the report
$reportPath = $env:TEMP + "\azdrfx\MarvelHeroes\report"
$reportFile = "$reportPath\HeroesReport.csv"

# Create the directory for the report and ignore the output
New-item -ItemType Directory -Path $reportPath -Force | Out-Null

# Export the input object to a CSV file
$inputObject | Export-Csv -Path $reportFile -NoTypeInformation

# Output a message to the console indicating the report generation
Write-Host " Report generated!"

# Output a message to the console indicating the site we're connecting to
Write-Host " Connect to Site - $($Env:AppSiteUrl)"

# Connect to the SharePoint Online site using the URL from the environment variable and Managed Identity
$conn = Connect-PnPOnline -Url $Env:AppSiteUrl -ManagedIdentity

# Output a message to the console indicating the upload process
Write-Host " Uploading report to Document Library - $DocLib [$reportFile]"

# Upload the report file to the document library
Add-PnPFile -Path $reportFile -Folder  "$DocLib\Comics"  -Values @{Modified="05/16/2024"} -Connection $conn |Out-Null

# Output a message to the console indicating the end of the upload process
Write-Host "  Report uploaded"

# Output a message to the console indicating the end of the script
Write-Host " Create Hero Report - End"

# Output the final status of the script
"Report uploaded to $DocLib"
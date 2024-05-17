# Script Name: pnp.ps1
# Purpose: This script is used to initialize PnP to be used in Azure durable functions
# Module: CORE
# Author: rpinto@pdragon.co
# Date: 03-02-2023

# Define a function to create a new member if it doesn't exist
function CreateIfDontExist($elem, $key) {
    # Check if the member exists
    if ($null -eq $elem.Values.$key) {
        # If it doesn't exist, create a new one
        Write-Host "    `e[32m...$key dont exist, so we will create a new one"
        $elem.Values | Add-Member -Name $key -Value "" -MemberType NoteProperty -Force
    }
}
# Remove the "core" module if it's already imported
Get-Module -Name "core" | Remove-Module

# Import the "core" module from the specified path
Import-Module $PSScriptRoot\pdragon-core.psm1

# Define the Azure Functions folder
$azFxFolder = "./"

# Start a message with the title " 🦔 PNP "
Start-Message -Title " 🦔 Add configuration from ..."

# read apps.json
# Function to create a flat PSObject from JSON
$jsonContent = Get-Content -Path "$PSScriptRoot\..\json\apps.json" | ConvertFrom-Json
# Read the JSON content
do {
    

    # Create a menu
    $index = 1
    Write-Host "   `e[37;1mGet Settings from ...`e[0m`n`r"
    $jsonContent.Apps | ForEach-Object {
        Write-Host "   `e[33;1m[$index. $($_.Name)]`e[0m"
        $_.Props | ForEach-Object {
            $_.PSObject.Properties | ForEach-Object {
                Write-Host "       `e[37m$($_.Name): $($_.Value)"
            }
        }
        Write-Host " "
        $index++
    }

    # Ask the user to select an option
    $selection = Read-Host "`e[32m   Option ?`e[33;1m"
    Write-Host ""
} while ($selection -notin (1, 2,3,4))
# Display the selected option
Write-Host "   `e[33;1m>>`e[36;1m $($jsonContent.Apps[$selection - 1].Name) `e[33;1m<<`e[0m`n`r"
Write-Host "   `e[37;1mApplying values in local.settings.json ....`e[32m"
$elemApps = $jsonContent.Apps[$selection - 1]

# Get the content of the local.settings.json file and convert it from JSON
$elem = (Get-Content -Path $azFxFolder\local.settings.json | ConvertFrom-Json)


# Get the properties of the Props object in the elemApps object
$props = $elemApps.Props | Get-Member -MemberType NoteProperty

# Loop through each property
foreach ($prop in $props) {
    # Get the name of the current property
    $fieldName = $prop.Name 
    # Call the CreateIfDontExist function with the current element and property name
    # This function is expected to create the property if it doesn't exist
    CreateIfDontExist -elem $elem -key $fieldName
    # Set the value of the property in the Values object of elem to the value of the property in the Props object of elemApps
    $elem.Values.$fieldName = $elemApps.Props.$fieldName
}

# # Sort the properties in the 'Values' object
# $sortedValues = $elem.Values.PSObject.Properties | Sort-Object Name

# # Create a new ordered hashtable to hold the sorted properties
# $newValues = New-Object -Type 'System.Collections.Specialized.OrderedDictionary'

# # Add the sorted properties to the new hashtable
# $sortedValues | ForEach-Object { $newValues.Add($_.Name, $_.Value) }

# # Replace the 'Values' object with the new sorted hashtable
# $elem.Values = $newValues

# Convert the content back to JSON and save it to the local.settings.json file
$elem | ConvertTo-Json  | Set-Content -Path $azFxFolder\local.settings.json
Write-Host "`n`r   `e[37;1mlocal.settings.json updated !`e[32m"

# Add to profile.ps1 the required mock module

$profileContent = Get-Content -Path $azFxFolder\profile.ps1 -Raw
if ($profileContent -notmatch "core.psm1") {
    
    $profileContent += "    
`
## [PDRAGON] SETTING FOR AZDURABLE FUNCTIONS LOCAL DEBUG 
if (`$env:APP_IS_LOCAL) {
    Import-Module  `$PSScriptRoot\.vscode\_pdragon\ps1\pdragon-core.psm1
}
"
    $profileContent | Set-Content -Path $azFxFolder\profile.ps1 -NoNewline
    Write-Host "`n`r   `e[37;1mprofile.ps1 updated !`e[32m"
}


# Stop message
Stop-Message


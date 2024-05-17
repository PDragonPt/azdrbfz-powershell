# Script Name: avengers.ps1
# Purpose: Initialize ; This script is used to clean up the azure durable functions state
# Module: CORE
# Author: rpinto@pdragon.co
# Date: 03-02-2023

# Declare a parameter for the script
param($azFxRootPath)
# Import Azure Functions PowerShell Worker module
# Remove the "core" module if it's already imported
Get-Module -Name "core"| Remove-Module

# Import the "core" module from the specified path
Import-Module $PSScriptRoot\pdragon-core.psm1

# Start a message with the title " 💀 PUNISHER "
Start-Message -Title " 💀 PUNISHER "

# Print a message about cleaning up durable functions storage
# and recreating a new TaskHubName on each F5 [local.settings.json file change]
"
  To make  sure all is cleaned up in durable functions storage, 
  We will recreate a new TaskHubName on each F5 [local.settings.json file change]

  azFxRootPath: [`e[37m$azFxRootPath`e[32m]
`e[37m`n`r"
" Cleaning up durable functions TasksHub - START

  Delete task hub TestHubName (default) (dont worry if it throws an error)"
  # Delete the task hub TestHubName (default)
# Don't worry if it throws an error
func durable delete-task-hub --task-hub-name TestHubName 

# Get the content of the local.settings.json file and convert it from JSON
$elem= (Get-Content -Path $azFxRootPath\local.settings.json | ConvertFrom-Json)

"  Delete task hub $oldName"
# Get the old TaskHubName
$oldName=$elem.Values.AzureFunctionsJobHost__extensions__durableTask__hubName

func durable delete-task-hub --task-hub-name $oldName 
"  TaskHubName PreviousName $oldName"

# Create a new TaskHubName
$taskHubName = "TestHubName$(Get-Random)"
$elem.Values |Add-Member -Name "AzureFunctionsJobHost__extensions__durableTask__hubName" -Value $taskHubName  -MemberType NoteProperty -Force
"  Created a new TaskHubName [$taskHubName]"
"$azFxRootPath\local.settings.json"
# Convert the content back to JSON and save it to the local.settings.json file
$elem |ConvertTo-Json  | Set-Content -Path $azFxRootPath\local.settings.json

# Stop the message
Stop-Message


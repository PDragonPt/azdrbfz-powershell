# Script Name: avengers.ps1
# Purpose: Initialize ; Create Symbolic Links in the current project and copy custom tasks+launch.json
# Module: CORE
# Author: rpinto@pdragon.co
# Date: 03-02-2023

# Define the Azure Functions folder
$azFxFolder=".\"

# Remove the "pdragon-core" module if it exists
Get-Module -Name "pdragon-core"| Remove-Module

# Import the "pdragon-core" module
Import-Module $PSScriptRoot\ps1\pdragon-core.psm1

# Define a function to create a new symbolic link
function New-SymbolicLink {
    param(
        $theFile,
        $theLinkFile
    )

    # Create the parent directory of the symbolic link
    $folder = Split-Path -Path $theLinkFile -Parent
    New-Item -ItemType Directory -Path $folder -ErrorAction SilentlyContinue | Out-Null

    # Define the commands to create and delete the symbolic link
    $cmdNew = "New-Item -ItemType SymbolicLink -Path " + $theLinkFile + " -Target " + $theFile 
    $cmdDelete = "Remove-Item  -Path " + $theLinkFile + " -ErrorAction SilentlyContinue"

    # Define the processes to create and delete the symbolic link
    $cmdProcessCreate = "pwsh -Verb RunAs -ArgumentList  '-Command','$cmdNew';  "
    $cmdProcessDelete = "pwsh -Verb RunAs -ArgumentList  '-Command','$cmdDelete' "

    # Delete the existing symbolic link
    $cmdProcess = " Start-Process -WindowStyle hidden $cmdProcessDelete "
    pwsh -Command $cmdProcess

    # Create the new symbolic link
    $cmdProcess = "Start-Process -WindowStyle hidden $cmdProcessCreate "
    Write-Host "  Create symbolic link to $theFile in $theLinkFile"
    pwsh -Command $cmdProcess
}

# Define a function to copy VS Code assets
function Copy-VsCodeAssets()
{
    param(
        [string]$folder
    )
    # Copy the json assets to the specified folder
    Write-Host "  Copying json assets[$PSScriptRoot\json] to $folder"
    Copy-Item -Path "$PSScriptRoot\json\launch.json" -Destination $folder  -Force
    Copy-Item -Path "$PSScriptRoot\json\tasks.json" -Destination $folder  -Force
}

# Clear the host
Clear-Host

# Start the message
Start-Message -Title " ✨ SANITIZE AzureCoreTools [Avengers]"

# Define the temp folder
$temp=$env:TEMP +"\azdrfx"

# Create the necessary directories
New-Item -ItemType Directory -Path "$azFxFolder\.vscode\_pdragon\json" -ErrorAction SilentlyContinue -Force| Out-Null
New-Item -ItemType Directory -Path "$azFxFolder\.vscode\_pdragon\ps1" -ErrorAction SilentlyContinue -Force| Out-Null
New-Item -ItemType Directory -Path "$azFxFolder\.vscode\_pdragon\temp" -ErrorAction SilentlyContinue -Force| Out-Null
New-Item -ItemType Directory -Path $temp -ErrorAction SilentlyContinue -Force| Out-Null

# Create the symbolic links
New-SymbolicLink -folder $azFxFolder -theFile $temp -theLinkFile "$azFxFolder\.vscode\_pdragon\temp"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\ps1\punisher.ps1" -theLinkFile "$azFxFolder\.vscode\_pdragon\ps1\punisher.ps1"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\ps1\pnp.ps1" -theLinkFile "$azFxFolder\.vscode\_pdragon\ps1\pnp.ps1"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\ps1\_droctopus.ps1" -theLinkFile "$azFxFolder\.vscode\_pdragon\ps1\_droctopus.ps1"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\ps1\pdragon-core.psm1" -theLinkFile "$azFxFolder\.vscode\_pdragon\ps1\pdragon-core.psm1"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\avengers.ps1" -theLinkFile "$azFxFolder\.vscode\_pdragon\ps1\avengers.ps1"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\json\launch.json" -theLinkFile "$azFxFolder\.vscode\_pdragon\json\launch.json"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\json\tasks.json" -theLinkFile "$azFxFolder\.vscode\_pdragon\json\tasks.json"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\json\apps.json" -theLinkFile "$azFxFolder\.vscode\_pdragon\json\apps.json"
New-SymbolicLink -folder $azFxFolder -theFile "$PSScriptRoot\ps1\DurableTask.AzureStorage.dll" -theLinkFile "$azFxFolder\.vscode\_pdragon\ps1\DurableTask.AzureStorage.dll"
# Copy the VS Code assets
Copy-VsCodeAssets -folder "$azFxFolder\.vscode\"

# Stop the message
Stop-Message

# Load the pnp.ps1 script
. $PSScriptRoot\ps1\pnp.ps1
# Script Name: droctopus.ps1
# Purporse: Aggregator of tasks
# Module: CORE
# Author: rpinto@pdragon.co
# Date: 03-02-2023

# Declare a parameter for the script
param($azFxRootPath)

# Dot source the punisher.ps1 script located in the same directory as this script
# This script is used to clean up the azure durable functions state
. $PSScriptRoot\punisher.ps1 -azFxRootPath $azFxRootPath

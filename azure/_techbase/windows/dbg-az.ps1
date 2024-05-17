# Script Name: dbg-az.ps1
# Purporse: for debug  (copy this to c:\windows )
# Module: CORE
# Author: rpinto@pdragon.co
# Date: 04-02-2023

#read local.settings.json from the az durable functions
$location= (Get-Location).Path
$json = Get-Content -Path "$location\..\local.settings.json"| ConvertFrom-Json

# Set environment variables
foreach ($var in $localSettings.Values.PSObject.Properties) {
    Set-Variable -Name "`$Env:$($var.Name)" -Value $var.Value
}
## this script has the Connect-Az and Connect-PnPPowerShell Wrapper for debugging local "managed instances"
. ..\..\_techbase\ps1\pdragon-core.psm1
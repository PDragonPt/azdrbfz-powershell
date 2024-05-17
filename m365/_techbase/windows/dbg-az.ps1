$location= (Get-Location).Path
$json = Get-Content -Path "$location\..\local.settings.json"| ConvertFrom-Json

# Set environment variables
foreach ($var in $localSettings.Values.PSObject.Properties) {
    Set-Variable -Name "`$Env:$($var.Name)" -Value $var.Value
}

. ..\..\_techbase\ps1\pdragon-core.psm1
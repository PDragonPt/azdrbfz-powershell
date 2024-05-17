# Define the company name
$company="🚀 PDRAGON TOOLING "

# Define the header with spaces
$header = " " * (80-$company1.Length-2)

# Define the divider with dashes
$divider="-" * 80

# Define the title header and footer with hashes
$titleHeader="#" * 50
$titleFooter="#" * 50

# Define the company trademark
$companyTradeMark="`e[44m`e[37;1m `e[44m                                   Perspective Dragon, 2022, rpinto@pdragon.co `e[0m"

# Define a function to start a message
function Start-Message($title) {
    # Print the company name, header, divider, title header, title, and title footer
    "`e[44m  `e[41m`e[37;1m$company`e[44m`e[37;1m$header`e[0m
`e[32m$divider
`e[32m  $titleHeader
`e[97m  $title 
`e[32m  $titleFooter`n`r"
}

# Define a function to stop a message
function Stop-Message() {
    # Print the divider and company trademark
    "`e[93#####################################################
`e[94m$divider
$companyTradeMark
`e[37m"
}

function Connect-AzAccount {
    param(
        [switch]$Identity )
        Disable-AzContextAutosave -Scope Process | Out-Null
        
        Az.Accounts\Connect-AzAccount -Subscription $Env:AppSubscriptionId `
        -ApplicationId $Env:AppClientId `
        -CertificateThumbprint $Env:AppCertThumbprint `
        -Tenant $Env:AppTenantId
        
        
        
    
}
# Define a function to override  Connect-PnPOnline for local dev
function Connect-PnPOnline {
    param(
        [string]$Url,
        [switch]$ManagedIdentity
    )

    # Connect to PnP Online and return the connection
    $connection=PnP.PowerShell\Connect-PnPOnline -Url $Url  `
    -Tenant $Env:AppTenant `
    -ClientId $Env:AppClientId `
    -Thumbprint $Env:AppCertThumbprint -ReturnConnection
    
    $connection
}
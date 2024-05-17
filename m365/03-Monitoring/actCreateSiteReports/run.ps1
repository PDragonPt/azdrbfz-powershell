# Define parameters for the script
param($inputObject)

# Get environment variables
[String]$ReportCenter = $env:AppReportCenter
[String]$SiteUrl= $env:AppSiteUrl
[String]$TeamsWebHookUrl= $env:AppTeamsWebHookUrl

# Start of the script
Write-Host "$Scope Start"

# Get all SharePoint sites
Write-Host "$Scope  Get all SharePoint sites"

# Construct siteAdminUrl from SiteUrl
$siteAdminUrl = $SiteUrl.Split(".sharepoint")[0] + "-admin.sharepoint.com" 

# Connect to SharePoint Online
Write-Host "$Scope  Connect to $siteAdminUrl"
$conn= Connect-PnPOnline -Url $siteAdminUrl -ManagedIdentity

# Get all tenant sites
Write-Host "$Scope  Get-PnPTenantSite"
$sites = Get-PnPTenantSite -Connection $conn

# Initialize results array
$results = [System.Collections.ArrayList]::new()
$siteCounter = 1
$siteCount = $sites.Count

# Process all sites
Write-Host "$Scope  Processing $siteCount sites..."
foreach ($site in $sites) {
  Write-Host "$Scope  $siteCounter/$siteCount - Get info from: $($site.Url)"
  
  # Create a custom object for each site
  $obj = [PSCustomObject]::new()
  $obj | Add-Member -MemberType NoteProperty -Name "Site" -Value $site.Title;
  $obj | Add-Member -MemberType NoteProperty -Name "SiteUrl" -Value $site.Url;
  $obj | Add-Member -MemberType NoteProperty -Name "SiteTemplate" -Value $site.Template;
  $obj | Add-Member -MemberType NoteProperty -Name "Status" -Value $site.Status;
  $obj | Add-Member -MemberType NoteProperty -Name "StorageQuota" -Value $site.StorageQuota;
  $obj | Add-Member -MemberType NoteProperty -Name "StorageQuotaWarningLevel" -Value $site.StorageQuotaWarningLevel;
  $obj | Add-Member -MemberType NoteProperty -Name "StorageUsageCurrent" -Value $site.StorageUsageCurrent;
  
  # Add the custom object to the results array
  $results.Add($obj) | Out-Null
  $siteCounter++
}

# Define report variables
$reportName = "SharePointReport"
$reportSite = (Split-Path $reportCenter -Parent).Replace('\', '/')
$reportDocLibPath = "$(([uri]$reportCenter).LocalPath)/SharePoint"

# Connect to the report site
Write-Host "$Scope  Connect to $reportSite "
$conn=Connect-PnPOnline -Url $reportSite -ManagedIdentity

# Define the local path for the report
$reportLocalPath = "{0}\{1}_{2}.csv" -f $env:TEMP, $reportName, (get-Date).toString("yyyyMMdd-HHmmsss") 

# Export the results to a CSV file
$results | Export-Csv -Path $reportLocalPath -NoTypeInformation

# Add the CSV file to the SharePoint document library
Write-Host "$Scope  $reportSite Add file"
Write-Host "$Scope   reportLocalPath:$reportLocalPath"
Write-Host "$Scope   reportDocLibPath :$reportDocLibPath"
$file = Add-PnPFile -Path $reportLocalPath -Folder $reportDocLibPath -Connection $conn

# Disconnect from SharePoint Online
Write-Host "$Scope   Disconnect-PnPOnline"
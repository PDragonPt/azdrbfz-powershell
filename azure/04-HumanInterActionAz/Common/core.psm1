# Function to send a message to Microsoft Teams using a webhook
function Send-Message($CardCaption,$CardTitle, $CardSubTitle,$CardText,$CardButtonText,$Actions, $TeamsWebHookUrl) {

   # Define the image and its size
   $Image = "https://cdn-icons-png.freepik.com/256/10720/10720894.png"
   $ImageSize = "250px"

   # Define the adaptive card JSON
   $reportCard= @"
   {
      "type":"message",
      "attachments":[
         {
            "content":{
               "`$schema":"<http://adaptivecards.io/schemas/adaptive-card.json>",
               "type":"AdaptiveCard",
               "version":"1.5",
               "body":[
                  {
                     "type":"ColumnSet",
                     "columns":[
                        {
                           "items":[
                              {
                                 "text":"$CardCaption",
                                 "size":"Large",
                                 "weight":"Bolder",
                                 "color":"Good",
                                 "wrap":true,
                                 "type":"TextBlock"
                              },
                              {
                                 "text":"$CardTitle",
                                 "size":"extraLarge",
                                 "weight":"bolder",
                                 "spacing":"none",
                                 "wrap":true,
                                 "type":"TextBlock"
                              },
                              {
                                 "type":"TextBlock",
                                 "size":"small",
                                 "maxLines":1,
                                 "text":"$CardSubTitle",
                                 "wrap":true
                              },
                              {
                                 "type":"TextBlock",
                                 "size":"small",
                                 "text":"$CardText[$CardText1Link]($CardText1LinkUrl)",
                                 "wrap":true
                              }
                           ],
                           "type":"Column",
                           "width":2
                        },
                        {
                           "items":[
                              {
                                 "type":"Image",
                                 "url":"$image",
                                 "altText":"1",
                                 "width":"$imageSize"
                              }
                           ],
                           "type":"Column",
                           "width":1
                        }
                     ]
                  }
               ],
               "actions":$actions
            },
            "contentType":"application/vnd.microsoft.card.adaptive"
         }
      ]
   }
"@

   # Convert the adaptive card JSON to a PowerShell object
   $JSON = ($reportCard | ConvertTo-JSON |  ConvertFrom-Json -Depth 10)

   # Define the parameters for the Invoke-RestMethod cmdlet
   $Params = @{
       "URI"         = $TeamsWebHookUrl
       "Method"      = 'POST'
       "Body"        = $JSON
       "ContentType" = 'application/json'
   }
       
   # Send the adaptive card to Microsoft Teams
   Invoke-RestMethod @Params | Out-Null
}

# Function to get the status of a durable function
function Get-DurableStatus($FunctionsURL, $InstanceId) {
   # Define the URL for the status endpoint
   $StatusURL = ("{0}/runtime/webhooks/durabletask/instances" -f $FunctionsURL)

   # Get the status of the durable function
   $Status = @(Invoke-RestMethod -Method GET -Uri $StatusURL)

   # Filter the status by instance ID
   if ($Status) {
       $Status = $Status | Where-Object { $_.instanceId -eq $InstanceId }
   }

   # Log the status
   Write-Host "Get-DurableStatus $status"

   # Return the status
   return $Status
}

# Function to send an external event to a durable function
function Send-DurableExternalEvent() {
  param (
    [Parameter(Mandatory = $true)]
    [string]$FunctionsURL,

    [Parameter(Mandatory = $true)]
    [string]$InstanceId,
    
    [Parameter(Mandatory = $true)]
    [string]$AppCode,
    
    [Parameter(Mandatory = $true)]
    [string]$EventName,

    [Parameter(Mandatory = $false)]
    [object]$EventDataJson
 )

  # Define the URL for the event endpoint
  $EventURL = ("{0}/runtime/webhooks/durabletask/instances/{1}/raiseEvent/{2}?code={3}" -f $FunctionsURL, $InstanceId, $EventName, $AppCode)

  try {
      # Send the external event to the durable function
      $null = Invoke-WebRequest -Method POST -Uri $EventURL -body $EventDataJson -ContentType 'application/json' -Headers @{"accept" = "application/json" }

      # Log the success
      Write-Host "Send-DurableExternalEvent success"
  }
  catch {
      # Log the failure
      Write-Host "Send-DurableExternalEvent failed"
  }
}
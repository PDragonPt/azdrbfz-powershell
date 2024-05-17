# Accepts a single parameter, the URL of the Teams webhook
param($TeamsWebHookUrl)


# Defines a function to send a message to a Teams channel
function Send-Message($fileLink, $TeamsWebHookUrl) {
    # Sets the text for the card
    $CardCaption = "Azure Durable Functions Rocks!"
    $CardTitle = "Process Just Ended !"
    $CardSubTitle = "List of Heroes is ready !";
    $CardText = "Check it out! "
    $CardButtonRedirect = $filelink
    $CardButtonText = "Go to Report"

    # Sets the image for the card
    $ImageSize = "110px"
    $Image = "https://cdn.dribbble.com/users/136021/screenshots/4737243/clone-dribbble.gif"
    $ImageSize = "250px"

    # Defines the JSON for the card
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
                "actions":[
                   {
                      "type":"Action.OpenUrl",
                      "url":"$CardButtonRedirect",
                      "title":"$CardButtonText"
                   }
                ]
             },
             "contentType":"application/vnd.microsoft.card.adaptive"
          }
       ]
    }
"@

    # Converts the JSON to a PowerShell object
    $JSON = ($reportCard | ConvertTo-JSON |  ConvertFrom-Json -Depth 10)

    # Defines the parameters for the web request
    $Params = @{
        "URI"         = $TeamsWebHookUrl
        "Method"      = 'POST'
        "Body"        = $JSON
        "ContentType" = 'application/json'
    }
        
    # Sends the web request
    Invoke-RestMethod @Params
}

# Sets the URL of the report file
$reportFile= "https://portal.azure.com/#view/Microsoft_Azure_Storage/ContainerMenuBlade/~/overview/storageAccountId/%2Fsubscriptions%2F7321b225-bf7f-4103-8442-7696a7c18951%2FresourceGroups%2Frg_cloudsum%2Fproviders%2FMicrosoft.Storage%2FstorageAccounts%2Fstocloudfilespt/path/reports/etag/%220x8DC72D11D66FAB9%22/defaultEncryptionScope/%24account-encryption-key/denyEncryptionScopeOverride~/false/defaultId//publicAccessVal/None"

# Sends the message
Send-Message -FileLink $reportFile -TeamsWebHookUrl $TeamsWebHookUrl

# Outputs a success message
"Successfully sent alert to machine $machineId!"
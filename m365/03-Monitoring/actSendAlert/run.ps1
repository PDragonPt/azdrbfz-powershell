# Define a parameter for the Teams webhook URL
param($TeamsWebHookUrl)

# Define a function to send a message to a Teams channel
function Send-Message($fileLink, $TeamsWebHookUrl) {
    # Define the content of the message
    $CardCaption = "Azure Durable Functions Rocks!"
    $CardTitle = "Process Just Ended !"
    $CardSubTitle = "List of Heroes is ready !"
    $CardText = "Check it out! "
    $CardButtonRedirect = $fileLink
    $CardButtonText = "Go to Report"

    # Define the image to be included in the message
    $Image = "https://cdn.dribbble.com/users/136021/screenshots/4737243/clone-dribbble.gif"
    $ImageSize = "250px"

    # Define a JSON string that represents the structure of the card
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

    # Convert the JSON string to a PowerShell object
    $JSON = ($reportCard | ConvertTo-JSON |  ConvertFrom-Json -Depth 10)

    # Define the parameters for the Invoke-RestMethod cmdlet
    $Params = @{
        "URI"         = $TeamsWebHookUrl
        "Method"      = 'POST'
        "Body"        = $JSON
        "ContentType" = 'application/json'
    }
        
    # Send the message to the Teams channel
    Invoke-RestMethod @Params
}

# Define the file link
$reportCenter= "https://xyz.sharepoint.com/sites/xyz/SitePages/ReportCenter.aspx#comics-report"

# Call the Send-Message function
Send-Message -FileLink $reportCenter -TeamsWebHookUrl $TeamsWebHookUrl

# Print a success message
"Successfully sent alert to machine $machineId!"
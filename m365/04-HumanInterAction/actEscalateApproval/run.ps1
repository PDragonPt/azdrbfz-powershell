# Define parameters for the script
param($Context)

# Define the caption for the card
$CardCaption="Approvals"

# Define the title for the card
$CardTitle="Start M365 Audit Report[Manager]"

# Define the subtitle for the card
$CardSubTitle="Please review : approve, or decline."

# Define the text for the card
$CardText="The approval process was escalate to you as a manager"

# Define the button text for the card
$CardButtonText=""

# Define the actions for the card
$Actions=@(
    @{
        # Define the "Approve" action
        "type"="Action.OpenUrl"
        "title"="Approve"
        "url"="http://localhost:7071/api/HttpTrigger?Action=Approve&InstanceId=$($context.InstanceId)"
    },
    @{
        # Define the "Decline" action
        "type"="Action.OpenUrl"
        "title"="Decline"
        "url"="http://localhost:7071/api/HttpTrigger?Action=Denied&InstanceId=$($context.InstanceId)"
    }
)| ConvertTo-Json

# Send the message to Microsoft Teams
Send-Message `
    -CardCaption $CardCaption `
    -CardTitle $CardTitle `
    -CardSubTitle $CardSubTitle `
    -CardText $CardText `
    -CardButtonText $CardButtonText `
    -Actions $Actions `
    -TeamsWebHookUrl $env:AppTeamsApprovalWebHookUrl
    

"Approval escalated."

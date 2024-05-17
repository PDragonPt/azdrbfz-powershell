# Define parameters for the script
param($name)

# Define the caption for the card
$CardCaption="Approvals"

# Define the title for the card, including the name parameter
$CardTitle="The Start M365 Audit Report was $name"

# Define the button text for the card
$CardButtonText=""

# Define the actions for the card as an empty array
$Actions="[]"

# Send the message to Microsoft Teams
Send-Message `
    -CardCaption $CardCaption `
    -CardTitle $CardTitle `
    -CardSubTitle $CardSubTitle `
    -CardText $CardText `
    -CardButtonText $CardButtonText `
    -Actions $Actions `
    -TeamsWebHookUrl $env:AppTeamsApprovalWebHookUrl

# Log the processed approval
"Approval processed.[$name]"
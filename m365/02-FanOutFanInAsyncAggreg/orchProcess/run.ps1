# Define a parameter for the script
param($Context)

# Extract the hero value from the context input
$hero = $Context.Input.hero.Value

# Invoke the 'actListHeroes' function with the hero as input
$allHeroes = Invoke-DurableActivity -FunctionName 'actListHeroes' -Input $hero 

# Initialize a variable for debugging
$breakHere = ""

# Initialize a variable to hold the output
$output = ""

# Loop through each hero in allHeroes
$tasks = foreach ($theHero in $allHeroes) {
    # Invoke the 'actSaveHeroes' function with the current hero as input
    # The '-NoWait' flag means this function is called asynchronously
    Invoke-DurableActivity -FunctionName 'actSaveHeroes' -Input $theHero -NoWait
}

# Wait for all tasks to complete and store the result in output
$output = Wait-DurableTask -Task $tasks

# Invoke the 'actGetHeroesResults' function with the output as input
$res = Invoke-DurableActivity -FunctionName 'actGetHeroesResults' -Input $output

# Invoke the 'actUploadHeroesImages' function with the hero as input
$tasks = Invoke-DurableActivity -FunctionName 'actUploadHeroesImages' -Input $hero

# Wait for all tasks to complete and append the result to output
$output = Wait-DurableTask -Task $tasks

# Output a completion message
Write-Host "Done!"

# Append the completion message to output
$output += "Done!"

# Return the output
$output
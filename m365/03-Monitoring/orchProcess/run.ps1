# Define a parameter for the context
param($Context)

# Extract the hero value from the context input
$hero = $Context.Input.hero.Value

# Invoke the 'actListHeroesClunkyWay' function with the hero as input
# This function returns a list of all heroes
$allHeroes = Invoke-DurableActivity -FunctionName 'actListHeroesClunkyWay' -Input $hero 

# Invoke the 'actCreateSiteReports' function
# This function creates site reports and does not return any value, hence the output is discarded using Out-Null
Invoke-DurableActivity -FunctionName 'actCreateSiteReports'  |Out-Null

# Invoke the 'actCreateHeroReport' function with the list of all heroes as input
# This function creates a report for each hero and does not return any value, hence the output is discarded using Out-Null
Invoke-DurableActivity -FunctionName 'actCreateHeroReport' -Input $allHeroes |Out-Null

# Return the list of all heroes
$allHeroes
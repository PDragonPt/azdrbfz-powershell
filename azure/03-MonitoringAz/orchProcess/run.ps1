# Accepts a single parameter, the context of the current orchestration
param($Context)

# Retrieves the hero name from the context
$hero = $Context.Input.hero.Value

# Calls the 'actListHeroesClunkyWay' function to retrieve a list of heroes
# The hero name is passed as an input to the function
$allHeroes = Invoke-DurableActivity -FunctionName 'actListHeroesClunkyWay' -Input $hero 

# Calls the 'actCreateHeroReport' function to create a report of the heroes
# The list of heroes is passed as an input to the function
Invoke-DurableActivity -FunctionName 'actCreateHeroReport' -Input $allHeroes 

# Returns the list of heroes
$allHeroes
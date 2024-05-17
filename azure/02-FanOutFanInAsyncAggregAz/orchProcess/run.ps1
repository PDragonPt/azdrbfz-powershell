# The script accepts a single parameter, which is the context of the orchestration.
param($Context)

# The hero name is extracted from the context.
$hero = $Context.Input.hero.Value

# The 'actListHeroes' activity function is invoked to retrieve a list of heroes.
$allHeroes = Invoke-DurableActivity -FunctionName 'actListHeroes' -Input $hero 

# The 'actSaveHeroes' activity function is invoked asynchronously for each hero to save their pictures.
# The '-NoWait' flag is used to make these calls non-blocking.
$tasks = foreach ($theHero in $allHeroes) {
    Invoke-DurableActivity -FunctionName 'actSaveHeroes' -Input $theHero -NoWait
}

# The 'Wait-DurableTask' function is used to wait for all the 'actSaveHeroes' tasks to complete.
$output = Wait-DurableTask -Task $tasks

# The 'actGetHeroesResults' activity function is invoked to retrieve the results of the 'actSaveHeroes' tasks.
$results=Invoke-DurableActivity -FunctionName 'actGetHeroesResults' -Input $output

# The 'actUploadHeroesImages' activity function is invoked to upload the heroes' images.
$tasks = Invoke-DurableActivity -FunctionName 'actUploadHeroesImages' -Input $hero

# The 'Wait-DurableTask' function is used to wait for the 'actUploadHeroesImages' task to complete.
$output = Wait-DurableTask -Task $tasks

# A completion message is appended to the output.
$output += "Done!"

# The output is returned.
$output
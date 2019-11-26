$arrayTotal = Get-Content .\Inputs\inputday4.txt | Sort-Object
$arrayTime = $arrayTotal.Substring(6,11)
$arrayDay = $arrayTotal.Substring(6,5) | Select-Object -Unique
$arrayAction = @()
foreach ($item in $arrayTotal){
    $len = $item.length
    $end = $len - 19
    $arrayAction += $item.Substring(19,$end)
}
#creates a custom object with an entry every day
$Objects = $null
foreach ($item in $arrayDay){
    #$item = '03-04'
    $minutes = [bool[]]::new(60)
    $itemIndex = $arrayDay.IndexOf($item)
    $previousItem = $arrayDay[$itemIndex - 1]
    
    $1DayArray = $arrayTotal -match $item 
    $1DayArrayFall = $1DayArray -match "falls"
    $1DayArrayWake = $1DayArray -match "wake"

    $previousDayArray = $arrayTotal -match $previousItem
    $previousDayLastIndex = $previousDayArray.Length -1
    
    #Figure out which Guard is working on the day a there's been sleeping
    if ($1DayArray[0] -match 'Guard')
    {
        $guardIndex = $arrayTotal.IndexOf($1DayArray[0])
        if ($arrayAction[$guardIndex] -match "Guard #\d\d\d\d"){
            $guard = $arrayAction[$guardIndex].Substring(7,5)
        }else{
            $guard = $arrayAction[$guardIndex].Substring(7,3)
        }
    }elseif($previousDayArray[$previousDayLastIndex] -match 'Guard')
        {
            $guardIndex = $arrayTotal.IndexOf($previousDayArray[$previousDayLastIndex])
            if ($arrayAction[$guardIndex] -match "Guard #\d\d\d\d"){
                $guard = $arrayAction[$guardIndex].Substring(7,5)
            }else{
                $guard = $arrayAction[$guardIndex].Substring(7,3)
            }
        }else{
            $previousDayArray
            $1DayArray
        }
    #Calculate the sleep times and set the sleep minute arrays up
    $minSleep = $null
    $minFallArray = @()
    $minWakeArray = @()
    if ($1DayArrayFall){
        foreach ($fall in $1DayArrayFall){
            $indexFall = $arrayTotal.IndexOf($fall)
            $minFall = ($arrayTime[$indexFall]).Substring(9,2)
            $minFallArray += $minFall
        }
        foreach($wake in $1DayArrayWake){
            $indexWake = $arrayTotal.IndexOf($wake)
            $minWake = ($arrayTime[$indexWake]).Substring(9,2)
            $minWakeArray += $minWake
        }
        foreach($calcFall in $minFallArray){
            $indexFall = $minFallArray.IndexOf($calcFall)
            $minSleep +=  $minWakeArray[$indexFall] - $calcFall
            for ($i = [int]$calcFall; $i -lt $minWakeArray[$indexFall]; $i++){
                $minutes[$i] = $true
            }
        }
    }
    #Create custom objects to store our info
    if ($minSleep){
        $Objects += @([PSCustomObject]@{
            Date = $item
            Guard = $guard
            Minutes = $minutes
            Time = $minSleep
        })
    }else{
        $Objects += @([PSCustomObject]@{
            Date = $item
            Guard = $guard
            Minutes = $minutes
            Time = 0    
        })
    }
}
#Create an object to store how often each unique card has been asleep on the same minute
$finalObjects = $null
$uniqueGuards = $Objects.Guard | Sort-Object -Unique
foreach ($guard in $uniqueGuards){
    $finalObjects += @([PSCustomObject]@{
        Guard = $guard
        Minutes = [int[]]::new(60)
    })
}
#Loop through all guard's minutes arrays to add up all the times they've been asleep on the same minute
$index = 0
foreach ($guard in $finalObjects.Guard){
    $match = $Objects -match $guard
        foreach($item in $match){
            for ($c = 0; $c -lt $item.Minutes.Length; $c++){
                if ($item.Minutes[$c]){
                    $finalObjects[$index].Minutes[$c]++
                }
            }
        }
    $index++
}
#Find the highest minute value and use that to figure out the guard ID and minute index
$max = (($finalObjects.Minutes) | Measure-Object -Maximum).Maximum
$result = $finalObjects | Where-Object {$_.Minutes -eq $max}
$answer = [int]$result.Guard * $result.Minutes.IndexOf([int]$max)
Write-Host "$($result.Guard)times $($result.Minutes.IndexOf([int]$max)) = $($answer)" -ForegroundColor Green


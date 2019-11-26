$arrayTotal = Get-Content .\Inputs\inputday4.txt | Sort-Object
$arrayTime = $arrayTotal.Substring(6,11)
$arrayDay = $arrayTotal.Substring(6,5) | Select-Object -Unique
$arrayAction = @()
foreach ($item in $arrayTotal){
    $len = $item.length
    $end = $len - 19
    #$item.Substring(19,$end)
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
#Calculate which Guard has slept the most
$uniqueGuards = $Objects.Guard | Sort-Object -Unique
$totalSleep = @()

foreach ($guard in $uniqueGuards){
    $match = $Objects -match $guard
    $totalSleep += $match.Time | Measure-Object -Sum
}
$max = (($totalSleep.Sum) | Measure-Object -Maximum).Maximum
$maxSleepIndex = $totalSleep.Sum.IndexOf($max)
Write-Host "Guard $($uniqueGuards[$maxSleepIndex])has slept the most with $($max) minutes" -ForegroundColor Green
$sleepiestGuardObject = $Objects -match $uniqueGuards[$maxSleepIndex]

#Calculate how often guard was asleep for each minute
$finalArray = $null
$finalArray = [int[]]::new(60)
#$sleepiestGuardObject.Count
foreach ($guardItem in $sleepiestGuardObject){
    for ($c = 0; $c -lt $guardItem.Minutes.Length; $c++){
        if ($guardItem.Minutes[$c]){
            $finalArray[$c]++
        }
    }
}
$maxMinute = (($finalArray) | Measure-Object -Maximum).Maximum
$maxMinuteIndex = $finalArray.IndexOf([int]$maxMinute)
$results = [int]$uniqueGuards[$maxSleepIndex] * [int]$maxMinuteIndex 
Write-Host "$($uniqueGuards[$maxSleepIndex])times $($maxMinuteIndex) = $($results)"  -ForegroundColor Green


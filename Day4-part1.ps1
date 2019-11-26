<#
if (Test-Path 'E:\Libraries\Documents\Scripting Projects\AdventOfCode\2018\Inputs')
{
    Set-Location 'E:\Libraries\Documents\Scripting Projects\AdventOfCode\2018\Inputs'
}else{
    Set-Location 'E:\GameDevStuff\AdventOfCode2018\Inputs'
}
#>
$arrayTotal = Get-Content .\Inputs\inputday4.txt | Sort-Object
#$test.Substring(6,11) | Sort-Object 
$arrayTime = $arrayTotal.Substring(6,11)
$arrayDay = $arrayTotal.Substring(6,5) | Select-Object -Unique
$arrayAction = @()
$arrayGuard = @()
#$array.Substring(19,9)
foreach ($item in $arrayTotal){
    $len = $item.length
    $end = $len - 19
    #$item.Substring(19,$end)
    $arrayAction += $item.Substring(19,$end)
}

#$arrayGuard = ($arrayAction -match "Guard #\d\d\d\d").Substring(7,5)
<#
$arrayGuard = ($arrayAction -match "Guard #\d{3,4}").Substring(7,5)
foreach ($item in $arrayTotal){
    if ($item -match )
}#>


if ($arrayAction[$guardIndex] -match "Guard #\d\d\d\d"){
    $guard = $arrayAction[$guardIndex].Substring(7,5)
}else{
    $guard = $arrayAction[$guardIndex].Substring(7,3)
}

#TODO: Create a custom object to store Guards and total time asleep

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
            #Write-Host "Found guard in yesterday's array
            $guardIndex = $arrayTotal.IndexOf($previousDayArray[$previousDayLastIndex])
            #$guard = $arrayAction[$guardIndex].Substring(7,5)
            if ($arrayAction[$guardIndex] -match "Guard #\d\d\d\d"){
                $guard = $arrayAction[$guardIndex].Substring(7,5)
            }else{
                $guard = $arrayAction[$guardIndex].Substring(7,3)
            }

        }else{
            #Write-Error "Can't find guard for $($item)"
            $previousDayArray
            $1DayArray
        }
    #Write-Host "Day $($item) with Guard $($guard)"
    $minSleep = $null
    $minFallArray = @()
    $minWakeArray = @()
    if ($1DayArrayFall){
        foreach ($fall in $1DayArrayFall){
            #$fall
            $indexFall = $arrayTotal.IndexOf($fall)
            $minFall = ($arrayTime[$indexFall]).Substring(9,2)
            $minFallArray += $minFall
        }
        foreach($wake in $1DayArrayWake){
            #$wake
            $indexWake = $arrayTotal.IndexOf($wake)
            $minWake = ($arrayTime[$indexWake]).Substring(9,2)
            #$minSleep += $minWake - $minFall
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
            #Time = $arrayTime.IndexOf($TimeSpaces[0])
            #Time = ($arrayTime -match $item).IndexOf($arrayTime -match $item)
            Time = $minSleep
        })
    }else{
        $Objects += @([PSCustomObject]@{
            Date = $item
            Guard = $guard
            Minutes = $minutes
            #Time = $arrayTime.IndexOf($TimeSpaces[0])
            #Time = ($arrayTime -match $item).IndexOf($arrayTime -match $item)
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
    #Write-Host "Total sleep for $($guard) is $(($match.Time | Measure-Object -Sum).Sum)"
}
#($totalSleep.Sum).Count
$max = (($totalSleep.Sum) | Measure-Object -Maximum).Maximum
$maxSleepIndex = $totalSleep.Sum.IndexOf($max)
Write-Host "Guard $($uniqueGuards[$maxSleepIndex])has slept the most with $($max) minutes" -ForegroundColor Green
$sleepiestGuardObject = $Objects -match $uniqueGuards[$maxSleepIndex]
#TODO: calculate which minute he was most likely asleep
#$minutesArray = [bool[]]::new(60)
#$minutesArray.length
<#
$i = 0
foreach ($element in $minutesArray){
    Write-Host $i
    Write-Host $minutesArray.IndexOf($element)
    $minutesArray[$i] = $true
    $i++
}
$minutesArray[40] = $true
$minutesArray[0] = $false
#>
<#
foreach($item in $sleepiestGuardObject.Date)
{
    $minutesObject += @([PSCustomObject]@{
    Date = $item
    Minutes = [bool[]]::new(60)   
    })
}#>
$finalArray = $null
$finalArray = [int[]]::new(60)
#$sleepiestGuardObject.Count
foreach ($guardItem in $sleepiestGuardObject){
#$guardItem
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

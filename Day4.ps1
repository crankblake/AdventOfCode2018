Set-Location 'E:\Libraries\Documents\Scripting Projects\AdventOfCode\2018\Inputs'
$arrayTotal = Get-Content .\inputday4.txt | Sort-Object
#$test.Substring(6,11) | Sort-Object 
$arrayTime = $arrayTotal.Substring(6,11)
$arrayDay = $arrayTotal.Substring(6,5) | Select-Object -Unique
$arrayAction = @()
#$array.Substring(19,9)
foreach ($item in $arrayTotal){
    $len = $item.length
    $end = $len - 19
    #$item.Substring(19,$end)
    $arrayAction += $item.Substring(19,$end)
}

$arrayGuard = ($arrayAction -match "Guard #\d\d\d\d").Substring(7,5)

$arrayTotal -match "Guard #"

#TODO: Create a custom object to store Guards and total time asleep

#creates a custom object with an entry every day

foreach ($item in $arrayDay){
    $item = '11-22'
    $1dayArray = $arrayTotal -match $item 
    $1dayArrayFall = $1dayArray -match "falls"
    $1dayArrayWake = $1dayArray -match "wake"
    
    $minSleep = $null
    $minFallArray = @()
    $minWakeArray = @()
    if ($1dayArrayFall){
        foreach ($fall in $1dayArrayFall){
            #$fall
            $indexFall = $arrayTotal.IndexOf($fall)
            $minFall = ($arrayTime[$indexFall]).Substring(9,2)
            $minFallArray += $minFall
        }
        foreach($wake in $1dayArrayWake){
            #$wake
            $indexWake = $arrayTotal.IndexOf($wake)
            $minWake = ($arrayTime[$indexWake]).Substring(9,2)
            #$minSleep += $minWake - $minFall
            $minWakeArray += $minWake
        }
        foreach($calcFall in $minFallArray){
            $indexFall = $minFallArray.IndexOf($calcFall)
            $minSleep +=  $minWakeArray[$indexFall] - $calcFall
        }
    }
    #Guard grab here
    $1dayArrayGuard = $arrayTotal | Select-String -SimpleMatch $1dayArray -Context 1,0
    $guard = $1dayArrayGuard | Select-String -SimpleMatch "Guard"
    Write-Host $guard
    if ($guard.Count -gt 1){
        #how do i find the right one?
        $guard = $guard[0]
    }
    #Write-Host $guard
    if ($minSleep){
        $Objects += @([PSCustomObject]@{
            Date = $item
            Guard = 'tba'
            #Time = $arrayTime.IndexOf($TimeSpaces[0])
            #Time = ($arrayTime -match $item).IndexOf($arrayTime -match $item)
            Time = $minSleep
        })
    }else{
        $Objects += @([PSCustomObject]@{
            Date = $item
            Guard = 'tba'
            #Time = $arrayTime.IndexOf($TimeSpaces[0])
            #Time = ($arrayTime -match $item).IndexOf($arrayTime -match $item)
            Time = 0    
        })
    }
}

<#
foreach ($guard in $Objects.Guard)
{
    Write-Host $guard
}

foreach ($min in $Objects)
{
    #$min = 'dif'
    $Objects.Time.$min.Time += 'dif'
}
#>

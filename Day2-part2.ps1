$runTime = (Get-Date)
Set-Location "C:\Users\JSMITH\Desktop"
$list = @(Get-Content .\input2.txt)
$run = $true

foreach ($string in $list)
{
    if ($run)
    {
        Write-Host "Looking at $($string)"
        For ($j = $list.IndexOf($string) + 1; $j -lt  $list.Count -and ($run); $j++)
        {
            $match = 0
            $miss = 0
            #Write-Host "`tMatching with $($list[$j])"
            $matchArray = @()
            For ($i = 0; $i -lt $string.Length; $i++)
            {
                if ($miss -lt 2)
                {
                    if ($string[$i] -eq $list[$j][$i])
                    {
                        #Write-Host "`t`tWe've got a match for $($string) and $($list[$j]) at index $($i)"
                        $match++
                        $matchArray += $string[$i]
                    }else{
                        #Write-Host "`t`tWe've got a miss for $($string) and $($list[$j]) at index $($i)" -ForegroundColor Red
                        $miss++
                    }
                    if ($i -eq $string.Length -1 -and $miss -lt 2)
                    {
                        Write-Host "We've got $($match) matches for $($string) and $($list[$j])" -ForegroundColor Green
                        $matchString = New-Object System.String($matchArray,0,$matchArray.Length)
                        Write-Host "The correct ID is $($matchString)" -ForegroundColor Green
                        $run = $false
                        break
                    }
                }else{
                    #Write-Host "`t`tWe've got more than one miss. Skipping $($list[$j])" -ForegroundColor Red
                    break
                }
            }
        }
    }  
}
$endTime = (Get-Date)
write-host "Elapsed Time: $([math]::Round(($endTime-$runTime).totalseconds, 2)) seconds"
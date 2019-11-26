cd C:\Users\JSMITH\Desktop
$numbers = Get-Content .\input.txt
$numbers = $numbers * 100000
$currentFreq = 0
$freq = @()

foreach ($c in $numbers)
{
    $currentFreq = $currentFreq + $c
    if ($freq.Contains($currentFreq)){
        Write-Host "$($currenFreq) is the first dupe"
        Break
    }
    $freq += $currentFreq
}
  
    

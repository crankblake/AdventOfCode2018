Set-Location "C:\Users\JSMITH\Desktop"
$list = @(Get-Content .\input2.txt)
$twice = 0
$thrice = 0

foreach ($string in $list)
{
    Write-Host "Looking at $($string)"

    $have3Match = $false
    $have2Match = $false
    $stringUnique = @($string.ToCharArray() | Select-Object -Unique)
    ForEach ($Element in $stringUnique)
    {
        if ((($string.ToCharArray() -match $Element).count -gt 2) -and (($string.ToCharArray() -match $Element).count -lt 4))
        {
            if ($have3Match -eq $false){
                Write-Host "Triple Dupe detected in $($Element)"
                $have3Match = $true
                $thrice++
            }else{
                Write-Host "Not adding $($Element) into Triples because we've already got a Triple Dupe"
            }
        }
        if ((($string.ToCharArray() -match $Element).count -gt 1) -and (($string.ToCharArray() -match $Element).count -lt 3))
        {
            if ($have2Match -eq $false){
                Write-Host "Double Dupe detected in $($Element)"
                $have2Match = $true
                $twice++
            }else{
                Write-Host "Not adding $($Element) into Doubles because we've already got a Double Dupe"
            }
        }
        if ((($string.ToCharArray() -match $Element).count -gt 0) -and (($string.ToCharArray() -match $Element).count -lt 2))
        {
            Write-Host "Single occurence in $($Element)"
        }
    }
}
  
Write-Host "Checksum is $($thrice * $twice)" -ForegroundColor Red


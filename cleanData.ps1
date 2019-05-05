# Script call docParses.vbs with parametr FilePath
# Files from data.
# From files remove all except table with data.

$scripPath = ".\bin\vbs\docParser.vbs"
$files     = Get-ChildItem .\data\*.doc
$footHead  = "--" * 20

if ($files.Count -eq 0) {
    $Progress = 1
} else {
    $Progress = [math]::Round(40 / $files.Count)  
}


Write-Output "`n--ParseData--`n$footHead`n$lineProg`n$footHead"
$steps = 0
$line  = 2

foreach ($file in $files) {
    $file_path  = "$file"
    $year       = "20" + $file.Name.Split(".")[0].Split("_")[0]
    $month      = [int]$file.Name.Split(".")[0].Split("_")[1]
	$colum_name = "$month.$year"

    if ($year -eq "2019" -And $month -eq 1) {
        $keyWord = "Таблица 2"
    } else {
        $keyWord = "Таблица 4"
    }
    
    & $scripPath $file_path $keyWord $line $colum_name

    sleep(3)
    if (Get-Process "WINWORD") {Wait-Process "WINWORD"}
    
    $steps   += $Progress
    $percent  = [math]::Round($steps / 0.4)
    $lineProg = '-' * $steps
    $line    += 1
    
    if ($files[$files.Count - 1] -eq $file) {
        $lineProg = $footHead
        $percent  = 100
    }
    
    clear
    Write-Output "`n--ParseData--[$percent  %]`n$footHead`n$lineProg`n$footHead"
}

if ($Progress -eq 1) {
    Write-Output "`nFiles not found!" 
} else {
    Write-Output "`nDone!"
}

sleep(2)

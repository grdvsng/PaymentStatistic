# Script call docParses.vbs with parametr FilePath
# Files from data.
# From files remove all except table with data.

$keyWord   = "Таблица 4"
$scripPath = ".\bin\vbs\docParser.vbs"
$files     = Get-ChildItem .\data\*.doc
$footHead  = "--" * 20

if ($files.Count -eq 0) {
    $Progress = 1
} else {
    $Progress = [math]::Round(40 / $files.Count)  
}


Write-Output "`n--ParseData--`n$footHead`n$lineProg`n$footHead"
foreach ($file in $files) {
    $file_path = "$file"
	& $scripPath $file_path $keyWord
    
    sleep(5)
    if (Get-Process "WINWORD") {Wait-Process "WINWORD"}
    
    $Progress += $Progress
    $lineProg = '-' * $Progress
    if ($files[$files.Count - 1] -eq $file) {$lineProg = $footHead}
    
    clear
    Write-Output "`n--ParseData--`n$footHead`n$lineProg`n$footHead"
}

if ($Progress -eq 1) {
    Write-Output "`nFiles not found!" 
} else {
    Write-Output "`nDone!"
}

sleep(2)

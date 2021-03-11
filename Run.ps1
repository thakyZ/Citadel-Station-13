$ProcessActive = (Get-Process dreamdaemon.exe -ErrorAction SilentlyContinue | ? {$_.SI -eq (Get-Process -PID $PID).SessionId})
if($ProcessActive -eq $null)
{
	$Path = "D:\Program Files (x86)\BYOND\bin"
    Write-host "Is Not Running, Do Start Process"
    $CUR_DATE = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    Start-Process -FilePath "$Path\dreamdaemon.exe" -ArgumentList "tgstation.dmb","-port 5000","-trusted","-close","-log `"data\logs\runtimes\runtime-$CUR_DATE.log`""
}
else
{
    Write-host "Is Running, Do Nothing"
}

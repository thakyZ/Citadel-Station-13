param (
	[Parameter(Mandatory=$false,HelpMessage="(Optional) Log to file")]
	[Switch]
	$Log,
	[Parameter(Mandatory=$false,HelpMessage="(Optional) Port for the server to run on.")]
	[int]
	$Port=24024
)

$byondInstall = $null;
$dreamDemonProc = "dreamdaemon";

if (Test-Path $env:DM_EXE) {
  $byondInstall = $env:DM_EXE;
} elseif (Test-Path (Get-ItemProperty -Path HKLM:\Software\Dantom\BYOND)) {
  $byondInstall = Get-ItemProperty -Path HKLM:\Software\Dantom\BYOND;
} elseif (Test-Path (Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Dantom\BYOND)) {
  $byondInstall = Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Dantom\BYOND;
}

$projectFolder = Get-Location;
if (Get-Location | Select-String -Pattern "tools")
{
    $projectFolder = Get-Location ".."
}

$date = Get-Date -Format "yyyy-MM-dd"

$byondArgs = "`"${projectFolder}\tgstation.dmb`"","-port","${Port}","-trusted","-close"
if ($Log) {
	$byondArgs += "-log","`"data\logs\runtimes\runtime-$($date).log`""
}

function Start-DreamDaemon() {
  $proc = Find-Process;
  if ($null -eq $proc) {
    $proc = Start-Process -FilePath "${byondInstall}\bin\dreamdaemon.exe" -ArgumentList $byondArgs
  }
  return $proc
}

function Find-Process() {
  $proc = Get-Process -Name $dreamDemonProc -ErrorAction SilentlyContinue
  if ($null -ne $proc) {
    return $proc
  }
  return $null
}

function Add-Folders() {
  if (-not (Test-Path "${projectFolder}\data")) {
	New-Item -ItemType Directory -Path "${projectFolder}\data" | Out-Null
  }
  if (-not (Test-Path "${projectFolder}\data\logs")) {
	New-Item -ItemType Directory -Path "${projectFolder}\data\logs" | Out-Null
  }
}

$date = Get-Date -Format G

while ($true) {
  if ($null -eq (Find-Process)) {
    Write-Host -ForegroundColor Red "Server is not runing"
	Start-DreamDaemon
	Add-Folders
	"Watchdog Started Headless DreamDaemon Server $($date)" | Add-Content "${projectFolder}\data\logs\watchdog.log"
  } else {
	  Write-Host -ForegroundColor Green "Server is running"
  }

  Start-Sleep -Seconds 10
}

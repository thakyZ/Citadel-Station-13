$BYOND_MAJOR=513
$BYOND_MINOR=1536
$DIR=$args[0]
$WebClient = New-Object System.Net.WebClient;
$WebClient.DownloadFile("http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond.zip", "${DIR}\byond.zip");

$WebClient.DownloadFile("https://www.7-zip.org/a/7z1900-x64.exe", "${DIR}\7z.exe");
(& "${DIR}\7z.exe" /S &&
    [System.Environment]::SetEnvironmentVariable('Path',
        [System.Environment]::GetEnvironmentVariable('Path',
            [System.EnvironmentVariableTarget]::User)+';c:\PROGRA~1\7zip',
        [System.EnvironmentVariableTarget]::User) &&
    Remove-Item "c:\byond\7z.exe") || exit 1


Set-Location "${DIR}"
(7z e byond.zip -oc:\byond *.* -r &&
    Copy-Item -Path "${DIR}\boynd\." -Recurse -Destination "${DIR}\." &&
    Remove-Item "${DIR}\byond.zip" &&
    [System.Environment]::SetEnvironmentVariable('Path',
        [System.Environment]::GetEnvironmentVariable('Path',
            [System.EnvironmentVariableTarget]::User)+';c:\PROGRA~1\7zip',
        [System.EnvironmentVariableTarget]::User)) || exit 1


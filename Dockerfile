# escape=`
ARG BASE
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-nanoserver-$BASE AS base

# byond = base + byond installed globally
WORKDIR /byond

COPY ["./dependencies.sh," "./"]

RUN pwsh -Command " `
    $BYOND_MAJOR=513
    $BYOND_MINOR=1536
    Invoke-WebRequest -Uri ((Invoke-WebRequest -Uri "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond.zip"))

    (Expand-Archive byond.zip -DestinationPath  -oc:\byond *.* -r &&
        Copy-Item -Path "/byond/boynd/." -Recurse -Destination "${DIR}\." &&
        Remove-Item "/byond/byond.zip" ) || exit 1`"



# build = byond + tgstation compiled and deployed to /deploy
WORKDIR /tgstation

RUN cmd /C .\Build.bat

# final = byond + runtime deps + rust_g + build
WORKDIR /tgstation

VOLUME [ "c:/tgstation/config", "c:/tgstation/data" ]
ENTRYPOINT [ "/byond/bin/dreamdaemon.exe", "tgstation.dmb", "-port", "5000", "-trusted", "-close", "-verbose" ]
EXPOSE 5000

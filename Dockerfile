# escape=`
ARG BASE
ARG BYOND_MAJOR
ARG BYOND_MINOR
FROM mcr.microsoft.com/windows/nanoserver:10.0.17763.$BASE AS base

# byond = base + byond installed globally
FROM base AS byond
WORKDIR /byond

RUN pwsh -Command "`
(Invoke-WebRequest -Uri "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond.zip" -UseBasicParsing -OutFile byond.zip && `
Expand-Archive byond.zip -DestinationPath . && `
Copy-Item -Path boynd/. -Recurse -Destination . && `
Remove-Item byond.zip ) || exit 1;"

# build = byond + tgstation compiled and deployed to /deploy
FROM byond AS build
WORKDIR /tgstation

RUN cmd /C .\Build.bat

# final = byond + runtime deps + rust_g + build
FROM byond
WORKDIR /tgstation

COPY --from=build /tgstation ./

VOLUME [ "c:/tgstation/config", "c:/tgstation/data" ]
ENTRYPOINT [ "/byond/bin/dreamdaemon.exe", "tgstation.dmb", "-port", "5000", "-trusted", "-close", "-verbose" ]
EXPOSE 5000

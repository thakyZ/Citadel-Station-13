# base = ubuntu + full apt update
FROM mcr.microsoft.com/windows:20H2-amd64 AS base

LABEL maintainer="950594+thakyZ@users.noreply.github.com"

# byond = base + byond installed globally
FROM base AS byond
WORKDIR "/byond"

COPY dependencies.sh .

RUN powershell ".\\download_byond.ps1" %CD%

# build = byond + tgstation compiled and deployed to /deploy
FROM byond AS build
WORKDIR /tgstation

RUN cmd /C .\Build.bat

# final = byond + runtime deps + rust_g + build
FROM byond
WORKDIR /tgstation

COPY --from=build /tgstation ./

VOLUME [ "c:/tgstation/config", "c:/tgstation/data" ]
ENTRYPOINT [ "DreamDaemon", "tgstation.dmb", "-port", "5000", "-trusted", "-close", "-verbose" ]
EXPOSE 5000

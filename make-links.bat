@echo off

move /Y "%~dp0config" "%~dp0config-bak"

mklink /d "%~dp0\config" "%~dp0\..\tgstation-server\gamedata\config"
mklink /d "%~dp0\cfg" "%~dp0\..\tgstation-server\gamedata\cfg"
mklink /d "%~dp0\data" "%~dp0\..\tgstation-server\gamedata\data"

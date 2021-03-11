@echo off

move /Y "%~dp0config" "%~dp0config-bak"

mklink /d "C:\Users\thaky\Development\Git\Games\Space Station 13\run\config" "C:\Users\thaky\Development\Git\Games\Space Station 13\tgstation-server\gamedata\config"
mklink /d "C:\Users\thaky\Development\Git\Games\Space Station 13\run\cfg" "C:\Users\thaky\Development\Git\Games\Space Station 13\tgstation-server\gamedata\cfg"
mklink /d "C:\Users\thaky\Development\Git\Games\Space Station 13\run\data" "C:\Users\thaky\Development\Git\Games\Space Station 13\tgstation-server\gamedata\data"

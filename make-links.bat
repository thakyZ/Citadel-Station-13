@echo off

move /Y "%~dp0config" "%~dp0config-bak"

mklink /d "C:\Users\thaky\Development\Git\Games\Space Station 13\Citadel-Station-13\config" "C:\Users\thaky\Development\Git\Games\Space Station 13\tgstation-server\gamedata\config"
mklink /d "C:\Users\thaky\Development\Git\Games\Space Station 13\Citadel-Station-13\cfg" "C:\Users\thaky\Development\Git\Games\Space Station 13\tgstation-server\gamedata\cfg"
mklink /d "C:\Users\thaky\Development\Git\Games\Space Station 13\Citadel-Station-13\data" "C:\Users\thaky\Development\Git\Games\Space Station 13\tgstation-server\gamedata\data"

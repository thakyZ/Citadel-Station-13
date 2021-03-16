@echo off
set COMMAND=
for %%X in (pwsh.exe) do (set FOUND=%%~$PATH:X)
if defined FOUND (
	set COMMAND="%FOUND%"
) else (
    for %%X in (powershell.exe) do (set FOUND=%%~$PATH:X)
	if defined FOUND (
		set COMMAND="%FOUND%"
	) else (
		echo No Powershell found.
		exit 1
	)
)
call %COMMAND% -Command ./tools/Run.ps1
exit 0

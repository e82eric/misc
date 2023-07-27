@echo off
@set SCRIPT_DIR=%~dp0
path|find /i "%SCRIPT_DIR%\debug_extensions\sosex"    >nul || set path=%path%;%SCRIPT_DIR%\debug_extensions\sosex
path|find /i "%SCRIPT_DIR%\debug_extensions\netext\x64"    >nul || set path=%path%;%SCRIPT_DIR%\debug_extensions\netext\x64
ECHO %PATH%
windbgx -c ".loadby sos clr; .load sosex; .load netext.dll; !windex" -z "%1"

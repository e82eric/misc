@ECHO off
@SET _dest=
@SET _rootDir=

IF "%~1" == "" SET _rootDir=%USERPROFILE%

FOR /F "delims=" %%I IN (
'dir /s /b /a:d %_rootDir% ^| fzf -e --layout reverse --info inline --bind="ctrl-y:execute(echo {} ^| clip)" --preview="tree /f /a {}" --preview-window=up'
) DO @SET "_dest=%%I"

IF [%_dest%] == [] EXIT /B

cd "%_dest%"

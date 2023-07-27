@ECHO off
@SET _dest=
@SET _rootDir=

IF "%~1" == "" (
  SET _rootDir=%USERPROFILE%
) ELSE (
  SET _rootDir=%~1
)

FOR /F "delims=" %%I IN (
'dir /s /b /a-d %_rootDir% ^| fzf -e --layout reverse --info inline --bind="ctrl-y:execute(echo {} ^| clip)" --preview-window=up --preview="bat.exe --style=numbers --theme=gruvbox-dark --color=always {}"'
) DO @SET "_dest=%%I"

IF [%_dest%] == [] EXIT /B

nvim "%_dest%"

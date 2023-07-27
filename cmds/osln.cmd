@ECHO off
@SET _dest=
@SET _dir=%1

IF "%_dir:~-4%"==".sln" (
  @SET _dest=%1
  GOTO RunRider
)

IF "%_dir%"=="" (
  ECHO "setting dir"
  @SET _dir=%USERPROFILE%
)

FOR /F "delims=" %%I IN (
'dir /s /b /a-d "%_dir%\*.sln" ^| fzf -e --layout reverse --info inline --bind="ctrl-y:execute(echo {} ^| clip)" --preview-window=up --preview="bat.exe --style=numbers --theme=gruvbox-dark --color=always {}"'
) DO @SET "_dest=%%I"

ECHO %_dir%
IF "%_dir:-~4%"==".sln" (
  ECHO "passed"
) ELSE (
  ECHO "not passed"
  ECHO %_dir%
)
IF [%_dest%] == [] EXIT /B

:RunRider
start "" "c:\Program Files\JetBrains\JetBrains Rider 2023.1.1\bin\rider64.exe" "%_dest%"

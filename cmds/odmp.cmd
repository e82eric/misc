@ECHO off
@SET _dest=
@SET _dir=%1

IF "%_dir:~-4%"==".dmp" (
  @SET _dest=%1
  GOTO RunWindbg
)

IF "%_dir%"=="" (
  ECHO "setting dir"
  @SET _dir=%USERPROFILE%
)

FOR /F "delims=" %%I IN (
'dir /s /b /a-d "%_dir%\*.dmp" ^| fzf -e --layout reverse --info inline --bind="ctrl-y:execute(echo {} ^| clip)" --preview-window=up --preview="bat.exe --style=numbers --theme=gruvbox-dark --color=always {}"'
) DO @SET "_dest=%%I"

ECHO %_dir%
IF "%_dir:-~4%"==".dmp" (
  ECHO "passed"
) ELSE (
  ECHO "not passed"
  ECHO %_dir%
)
IF [%_dest%] == [] EXIT /B

:RunWindbg
start "" "windbgx" "%_dest%"

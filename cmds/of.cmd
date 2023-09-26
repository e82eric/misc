@ECHO off
setlocal EnableDelayedExpansion
@SET _dest=
@SET _rootDir=
@SET _queryString=

IF "%~2" == "" (
  IF "%~1" == "" (
    SET _rootDir=%USERPROFILE%
  ) ELSE (
    if exist %~1\ (
      SET _rootDir=%~1
    ) else (
      SET _queryString=%~1
      SET _rootDir=%USERPROFILE%
    )
  )
) ELSE (
  SET _rootDir=%~1
  SET _queryString=%~2
)

FOR /F "delims=" %%I IN (
'dir /s /b /a-d "!_rootDir!" ^| fzf --query="!_queryString!" -e --layout reverse --info inline --bind="ctrl-y:execute(echo {} ^| clip)" --preview-window=up --preview="bat.exe --style=numbers --theme=gruvbox-dark --color=always {}"'
) DO @SET "_dest=%%I"

IF "!_dest!" == "" EXIT /B

nvim "!_dest!"

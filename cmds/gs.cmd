@ECHO off
@SET _dest=
@SET _line=

SET _searchString=%*
IF "%~1" == "" SET /p "_searchString=Search Stirng > "

FOR /F "delims=" %%I IN (
'rg --crlf --no-messages --hidden -i --vimgrep "%_searchString%" ^| fzf --delimiter=: --preview "bat --color=always --style=numbers --theme=gruvbox-dark --highlight-line {2} {1}" --preview-window="+{2}+3/2" --preview-window=up'
) DO @SET "_dest=%%I"

for /F "tokens=1,2 delims=:" %%a in ("%_dest%") do (
   SET _dest=%%a
   SET _line=%%b
)

if "%_dest%"=="" (
  EXIT /B
)
if "%_line%"=="" (
  EXIT /B
)

nvim "%_dest%" +%_line%

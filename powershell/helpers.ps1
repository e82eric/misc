function AddToMachinePath($pathToAdd)
{
  $oldPath = [Environment]::GetEnvironmentVariable("PATH", "MACHINE")
  $newPath = "$($oldPath);$($pathToAdd)"

  Write-Host "New path is going to be:"
  Write-Host ""
  Write-Host $newPath
  Write-Host ""

  $confirmation = Read-Host "Confirm [y/n]"
  if ($confirmation -eq 'y')
  {
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "MACHINE")
  }
}

function FormatXml
{
  param($string)
    $Indent = 4
    $xml = [xml]($string)
    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter
    $xmlWriter.Formatting = "indented"
    $xmlWriter.Indentation = $Indent
    $xml.WriteContentTo($XmlWriter)
    $XmlWriter.Flush()
    $StringWriter.Flush()
    Write-Output $StringWriter.ToString()
}

function FormatJson
{
  param($string)
    $result = $string | ConvertFrom-Json | ConvertTo-Json -depth 100
    $result
}

function TryJson
{
  param($string)
    $first = $string.IndexOf('{')
    $last = $string.LastIndexOf('}')
    $string.SubString(0, $first)
    $result = FormatJson $string.SubString($first, $last - $first + 1)
    $result
}

function OneLineJson
{
  param($string)
    $result = $string | ConvertFrom-Json | ConvertTo-Json -depth 100 -Compress
    $result
}

function Base64Encode
{
  param($string)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($string)
    $result = [Convert]::ToBase64String($bytes)
    $result
}

function Base64Decode
{
  param($string)
    $bytes = [Convert]::FromBase64String($string)
    $result = [Text.Encoding]::UTF8.GetString($bytes)
    $result
}

function OpenDirectory
{
  $fzfStr = fdir.cmd $args
  cd $fzfStr
}
Set-Alias -name od -value OpenDirectory

function Invoke-CmdScript {
  param(
    [String] $scriptName
  )
  $cmdLine = """$scriptName"" $args & set"
  & $Env:SystemRoot\system32\cmd.exe /c $cmdLine |
  select-string '^([^=]*)=(.*)$' | foreach-object {
    $varName = $_.Matches[0].Groups[1].Value
    $varValue = $_.Matches[0].Groups[2].Value
    set-item Env:$varName $varValue
  }
}

function setvcvars
{
  Invoke-CmdScript setvcvars.bat
}

# oh-my-tiny-powershell

function prompt {
  $ESC = [char]27
  $RED = "$ESC[38;2;219;69;82m"
  $ORIG = "$ESC[0m"
  $DEEP_BLUE = "$ESC[38;2;59;120;255m"
  $BLUE = "$ESC[38;2;58;150;221m"
  $GREEN = "$ESC[38;2;19;161;14m"
  $GRAY = "$ESC[38;2;204;204;204m"
  $YELLOW = "$ESC[38;2;249;241;165m"

  $username = "${BLUE}$env:username${ORIG}"
  $computer_name = "${GREEN}$env:COMPUTERNAME${ORIG}"
  $path = "${YELLOW}$((Get-Location).ToString())${ORIG}"
  $time = "${GRAY}[$(Get-Date -Format HH:mm:ss)]${ORIG}"

  $return_code = ""
  if ($LastExitCode -ne 0) {
    $return_code = "C:${RED}${LastExitCode}${ORIG}"
  }

  "`n${DEEP_BLUE}#${ORIG} $username @ ${computer_name} ${GRAY}in${ORIG} $path $time ${return_code}`n${RED}PS${ORIG}> "
}

Set-PSReadLineKeyHandler -Chord UpArrow -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Chord DownArrow -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadlineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Chord Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord Alt+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Alt+b -Function BackwardWord
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit 


$ssh_config = "~/.ssh/config"
Register-ArgumentCompleter -Native -CommandName ssh -ScriptBlock {
    param($hostName)
    $hosts = @()
    if (Test-Path $ssh_config -PathType Leaf) {
      return Select-String -path $ssh_config "Host ([\w-]*${hostName}[\w-]*)" -AllMatches | Foreach-Object {$_.Matches} | Foreach-Object {$_.Groups[1].Value}
    }
}

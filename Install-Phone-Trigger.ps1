$ErrorActionPreference = 'Stop'
$launcher = Join-Path $PSScriptRoot 'On-Phone-Arrival.bat'
$escaped = [System.Security.SecurityElement]::Escape($launcher)
$user = [System.Security.SecurityElement]::Escape("$env:USERDOMAIN\$env:USERNAME")
$xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Triggers><EventTrigger><Enabled>true</Enabled><Subscription>&lt;QueryList&gt;&lt;Query Id="0" Path="Microsoft-Windows-DriverFrameworks-UserMode/Operational"&gt;&lt;Select Path="Microsoft-Windows-DriverFrameworks-UserMode/Operational"&gt;*[System[(EventID=2003)]]&lt;/Select&gt;&lt;/Query&gt;&lt;/QueryList&gt;</Subscription></EventTrigger></Triggers>
  <Principals><Principal id="Author"><UserId>$user</UserId><LogonType>InteractiveToken</LogonType><RunLevel>LeastPrivilege</RunLevel></Principal></Principals>
  <Settings><MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy><DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries><StopIfGoingOnBatteries>false</StopIfGoingOnBatteries><ExecutionTimeLimit>PT0S</ExecutionTimeLimit><Enabled>true</Enabled></Settings>
  <Actions Context="Author"><Exec><Command>$escaped</Command></Exec></Actions>
</Task>
"@
Register-ScheduledTask -TaskName 'AndroidMic Phone Arrival' -Xml $xml -Force | Out-Null
Write-Host 'Installed. Reconnect the phone while signed in to test.'

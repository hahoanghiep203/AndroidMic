$ErrorActionPreference = 'Stop'
$svcl = Join-Path $PSScriptRoot 'tools\svcl\svcl.exe'
if (-not (Test-Path -LiteralPath $svcl)) { throw 'Missing tools\svcl\svcl.exe. Restore the complete repository.' }
$file = Join-Path ([IO.Path]::GetTempPath()) ("androidmic-" + [guid]::NewGuid().ToString() + '.csv')
try {
    & $svcl /scomma $file /Columns 'Name,Type,Direction,Device State,Command-Line Friendly ID'
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $file)) { throw 'Could not enumerate Windows audio devices.' }
    $rows = @(Get-Content -LiteralPath $file | ConvertFrom-Csv -Header Name,Type,Direction,State,FriendlyId)
} finally { Remove-Item -LiteralPath $file -ErrorAction SilentlyContinue }
$cable = @($rows | Where-Object { $_.Type -eq 'Device' -and $_.Direction -eq 'Render' -and $_.State -eq 'Active' -and $_.FriendlyId -match '^VB-Audio Virtual Cable\\Device\\CABLE In(?:put| 16ch)\\Render$' })
if ($cable.Count -eq 0) {
    Write-Host 'VB-CABLE input was not found. Download the official driver from https://vb-audio.com/Cable/.'
    Write-Host 'Extract it, run VBCABLE_Setup_x64.exe as administrator, install the driver, and restart Windows if requested. Then run this script again.'
    Start-Process 'https://vb-audio.com/Cable/'
    exit 1
}
Write-Host "VB-CABLE is available: $($cable.Name -join ', ')."
Write-Host 'AndroidMic will route its scrcpy session to the cable. Select CABLE Output as the microphone in your app.'

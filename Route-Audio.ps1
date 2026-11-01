param([Parameter(Mandatory=$true)][int]$ProcessId)
$ErrorActionPreference = 'Stop'
$svcl = Join-Path $PSScriptRoot 'tools\svcl\svcl.exe'
if (-not (Test-Path -LiteralPath $svcl)) { throw 'Audio routing utility is missing. See README.md.' }
function Get-AudioItems {
    $file = Join-Path ([IO.Path]::GetTempPath()) ("androidmic-" + [guid]::NewGuid().ToString() + '.csv')
    try {
        & $svcl /scomma $file /Columns 'Name,Type,Direction,Device State,Command-Line Friendly ID,Item ID'
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $file)) { throw 'Could not enumerate Windows audio devices.' }
        @(Get-Content -LiteralPath $file | ConvertFrom-Csv -Header Name,Type,Direction,State,FriendlyId,ItemId)
    } finally { Remove-Item -LiteralPath $file -ErrorAction SilentlyContinue }
}
$endpoints = @(Get-AudioItems | Where-Object {
    $_.Type -eq 'Device' -and $_.Direction -eq 'Render' -and $_.State -eq 'Active' -and
    $_.FriendlyId -match '^VB-Audio Virtual Cable\\Device\\CABLE In(?:put| 16ch)\\Render$'
})
if ($endpoints.Count -eq 0) { throw 'No active VB-CABLE input found. Install or enable VB-CABLE; see README.md.' }
$endpoint = @($endpoints | Sort-Object @{Expression={ if ($_.Name -eq 'CABLE Input') { 0 } else { 1 } }})[0]
$sessions = @()
for ($i = 0; $i -lt 20; $i++) {
    if (-not (Get-Process -Id $ProcessId -ErrorAction SilentlyContinue)) { throw 'scrcpy stopped before audio routing completed.' }
    $sessions = @(Get-AudioItems | Where-Object { $_.Type -eq 'Application' -and $_.Name -eq 'scrcpy.exe' -and $_.ItemId -match ("%b" + $ProcessId + '$') })
    if ($sessions.Count -gt 0) { break }
    Start-Sleep -Seconds 1
}
if ($sessions.Count -eq 0) { throw 'scrcpy audio session did not appear.' }
& $svcl /SetAppDefault $endpoint.ItemId all $ProcessId
if ($LASTEXITCODE -ne 0) { throw 'Windows rejected the per-app audio route.' }
for ($i = 0; $i -lt 10; $i++) {
    Start-Sleep -Seconds 1
    $active = @(Get-AudioItems | Where-Object { $_.Type -eq 'Application' -and $_.Name -eq 'scrcpy.exe' -and $_.State -eq 'Active' -and $_.ItemId.StartsWith($endpoint.ItemId + '|') -and $_.ItemId -match ("%b" + $ProcessId + '$') })
    if ($active.Count -gt 0) { Write-Host "scrcpy routed to $($endpoint.Name)."; exit 0 }
}
throw 'Could not verify that scrcpy switched to VB-CABLE. Check Windows Volume mixer.'

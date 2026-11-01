$ErrorActionPreference = 'Stop'
$scrcpy = Join-Path $PSScriptRoot 'scrcpy\scrcpy.exe'
$process = Start-Process -FilePath $scrcpy -ArgumentList '--select-usb','--audio-source=mic-voice-communication','--no-window','--audio-buffer=100','--require-audio' -PassThru -NoNewWindow
try {
    & (Join-Path $PSScriptRoot 'Route-Audio.ps1') -ProcessId $process.Id
} catch {
    Write-Warning $_
    Write-Warning 'Choose CABLE Input for scrcpy in Windows Volume mixer, or run Setup-Audio.ps1.'
}
Wait-Process -Id $process.Id -ErrorAction SilentlyContinue

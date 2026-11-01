@echo off
powershell.exe -NoProfile -Command "$p=Join-Path ([Environment]::GetFolderPath('Startup')) 'AndroidMic.lnk'; if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p }"
echo Auto-start shortcut removed. Close any running AndroidMic window separately.
pause

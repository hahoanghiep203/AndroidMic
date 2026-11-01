@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Startup') + '\AndroidMic.lnk'); $s.TargetPath='%~dp0AndroidMic.bat'; $s.WorkingDirectory='%~dp0'; $s.Save()"
echo Auto-start installed for this Windows user. It starts at your next sign-in.
pause

@echo off
setlocal
cd /d "%~dp0"
rem Give ADB time to discover and authorize the USB device.
for /l %%i in (1,1,30) do (
  scrcpy\adb.exe -d get-state 2>nul | findstr /x "device" >nul && goto connected
  timeout /t 1 /nobreak >nul
)
exit /b
:connected
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Start-AndroidMic.ps1"
exit /b

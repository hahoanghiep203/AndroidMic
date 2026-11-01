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
scrcpy\scrcpy.exe --select-usb --audio-source=mic-voice-communication --no-window --audio-buffer=100 --require-audio
exit /b

@echo off
title Android Phone as PC Microphone - Auto Retry

echo ================================
echo Android Phone Mic via scrcpy
echo Auto retry when disconnected
echo ================================
echo.

echo Make sure:
echo 1. USB debugging is enabled
echo 2. Phone is connected by USB
echo 3. Phone screen is unlocked
echo 4. VB-CABLE is installed if you want to use it as a mic in Discord/OBS/etc.
echo.

:loop
echo.
echo [%date% %time%] Starting Android microphone...
echo.

"%~dp0scrcpy\adb.exe" -d wait-for-device
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Start-AndroidMic.ps1"

echo.
echo [%date% %time%] scrcpy stopped or device disconnected.
echo Retrying in 5 seconds...
echo Press Ctrl + C to stop.
echo.

timeout /t 5 /nobreak >nul
goto loop

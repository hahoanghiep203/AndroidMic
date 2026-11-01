# Android phone microphone

Windows portable bundle using scrcpy 4.0. Extract the ZIP, enable Developer options and USB debugging on the phone, connect it by USB, unlock it, and approve the debugging prompt. Run AndroidMic.bat. Press Ctrl+C to stop the retry loop.

For automatic startup, keep the extracted folder in a permanent location and run Install-AutoStart.bat once. At each Windows sign-in, AndroidMic opens a console and waits for an authorized device, then starts scrcpy. Reconnecting retries automatically. Run Remove-AutoStart.bat to remove the startup shortcut. The installer does not start the current session: run AndroidMic.bat once now if desired. Avoid running multiple copies. With multiple USB debugging devices connected, scrcpy requires a single USB device to be selected. The first authorization must still be approved on the phone.

scrcpy forwards microphone audio to a Windows playback device; it does not create a microphone input. For Discord or OBS, install VB-CABLE separately, route scrcpy's output to CABLE Input in Windows volume mixer, then select CABLE Output as the microphone. Do not set CABLE Input as your general default output unless intended. See https://vb-audio.com/Cable/ for installation.

The bundle includes the installed scrcpy Windows binaries and adb. Android 11 or newer is required for audio forwarding. USB debugging must remain enabled. If the connection drops, try another data cable or USB port. scrcpy source, license, and official releases: https://github.com/Genymobile/scrcpy

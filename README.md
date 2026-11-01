# AndroidMic

Use an Android phone as a Windows microphone over USB with scrcpy. AndroidMic can start when Windows detects a phone connection, without keeping a microphone window open while you wait.

## Requirements

- Windows and an Android phone running Android 11 or newer.
- A USB cable that supports data.
- Developer options and **USB debugging** enabled on the phone.
- [VB-CABLE](https://vb-audio.com/Cable/) if you want to select the audio as a microphone in Discord, OBS, or another app.

The repository includes scrcpy 4.0 and ADB; you do not need to install them separately. USB debugging must remain enabled while you use AndroidMic.

## Set up on a Windows PC

Repeat these steps on each PC where you want to use the phone.

1. Download this repository using **Code → Download ZIP** on GitHub. Extract it to a permanent folder; the scheduled task refers to that folder.
2. Connect and unlock the phone. When asked to allow USB debugging, select **Always allow from this computer** and tap **Allow**. Each PC must be authorized separately.
3. Open **Command Prompt as administrator** and enable the Windows device event log:

   ```cmd
   wevtutil sl Microsoft-Windows-DriverFrameworks-UserMode/Operational /e:true
   ```

4. Open PowerShell in the extracted folder and register the task for your Windows account:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-Phone-Trigger.ps1
   ```

5. Check audio setup from the same folder:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Setup-Audio.ps1
   ```

   If VB-CABLE is missing, follow the displayed instructions to install the official driver, restart if requested, and run the check again.
6. While signed in, unplug and reconnect the phone. Windows should start the microphone session automatically. It closes when scrcpy stops. On first connection, allow up to 30 seconds for ADB to detect the phone.

The trigger depends on a Windows driver-arrival event. It worked with the Samsung phone used to test this project, but events can differ by PC, phone, or USB mode. Other device arrivals may also start a brief ADB check. If more than one USB debugging device is connected, scrcpy may require you to disconnect the others.

## Use the phone in Discord or OBS

scrcpy plays the phone's microphone audio through a Windows **output** device; it does not create a Windows microphone by itself.

1. Install [VB-CABLE](https://vb-audio.com/Cable/) on the PC.
2. Start an AndroidMic session. AndroidMic uses the bundled NirSoft SoundVolumeCommandLine utility to route that scrcpy process to an active VB-CABLE input without changing the system default output. If routing fails, open Windows **Settings → System → Sound → Volume mixer** and set scrcpy's output device to **CABLE Input** manually.
3. In Discord, OBS, or your other app, select **CABLE Output** as the microphone/input device.
4. Speak into the phone and check the app's input meter. Avoid setting CABLE Input as the default output for all Windows audio unless you intend to route all of it into the cable.

## Manual use

Run `AndroidMic.bat` to wait for an authorized USB phone and retry after disconnects. Press **Ctrl+C** to stop it. This is separate from the event-triggered task; avoid running both at once.

The older `Install-AutoStart.bat` starts a waiting console at Windows sign-in. Use `Remove-AutoStart.bat` to remove that shortcut. Do not enable both startup methods.

## Remove the phone connection trigger

In PowerShell, from the project folder, run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Remove-Phone-Trigger.ps1
```

This removes the scheduled task; it does not disable the Windows event log or uninstall VB-CABLE.

## Troubleshooting

- **Phone not detected or unauthorized:** Unlock it, check USB debugging, accept the PC's authorization prompt, and try another data cable or USB port. Run `scrcpy\adb.exe devices -l` from the project folder; the phone should show `device`.
- **No automatic start:** Confirm that the event log is enabled and the scheduled task is installed for the signed-in Windows user. Reconnect the phone and try another USB mode. Run `AndroidMic.bat` to test the connection manually.
- **No sound in Discord or OBS:** Confirm scrcpy is routed to CABLE Input and the app uses CABLE Output. Check the app's input level and microphone permissions.
- **Connection drops:** Try another data cable or USB port. The manual script retries; the event-triggered session exits and relies on a new arrival event to start again.

scrcpy is an independent open-source project. See its [official repository](https://github.com/Genymobile/scrcpy) for source, license, and releases.

The bundled [SoundVolumeCommandLine](https://www.nirsoft.net/utils/sound_volume_command_line.html) is freeware by Nir Sofer; its original package and license information are in `tools/svcl`.

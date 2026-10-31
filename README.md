# Kodi 21.3 "Omega" with AC-4 audio

Kodi 21.3 for Windows (64-bit), Linux (64-bit) and Android (phones, tablets,
Fire TV) that
plays **AC-4 audio**, the Dolby format used by ATSC 3.0 ("NextGen TV")
broadcasts, some DVB services and streaming. Stock Kodi can't decode AC-4, so
NextGen channels play without sound.

**Download** from the [Releases](../../releases) page:

- **Windows:** `Kodi-21.3-AC4-x64-setup.exe`. It installs like the official
  Kodi 21.3 and replaces an existing Kodi 21 installation; your settings and
  library are kept.
- **Android:** `Kodi-21.3-AC4-arm64.apk`, for 64-bit ARM devices (nearly all
  phones and tablets from the last several years) with Android 5.0 or later.
  See [Installing on Android](#installing-on-android) below.
- **Fire TV and 32-bit Android:** `Kodi-21.3-AC4-armv7.apk`, for Fire TV
  sticks and other devices that run only 32-bit apps. See
  [Fire TV](#fire-tv) below. (Not yet tested on a Fire TV: please report how
  it works.)
- **Linux:** `Kodi-21.3-AC4-x86_64.AppImage`, for 64-bit PCs with a
  distribution from 2022 or later. See [Linux](#linux) below. (So far tested
  only under WSL on Windows, not on real Linux hardware: please report how it
  works.)

## Installing on Android

The APK installs as a separate app beside a Kodi from the Play Store (package
`org.xbmc.kodiac4`), with its own settings and add-ons, so you can keep both.
Its icon is also labeled "Kodi"; in Android's app list (Settings > Apps) the
two can be told apart by their package names.

1. **Download the APK on the phone or tablet.** Open the
   [Releases](../../releases) page in the device's browser and tap
   `Kodi-21.3-AC4-arm64.apk`. (Or download it on a PC and copy it over USB, or
   through a cloud drive, to the device's Downloads folder.)
2. **Open it.** Tap the download when it finishes, or open it from the Files
   app (Downloads).
3. **Allow the install.** The first time, Android says that, for your
   security, it can't install unknown apps from this source. Tap
   **Settings**, turn on **Allow from this source** for the browser or Files
   app you opened it with, and go back. (On Android 7 and older, the switch
   is **Unknown sources** under Settings > Security.)
4. **Tap Install.** If Google Play Protect warns that the app is from an
   unknown developer, or offers to scan it, choose **Install anyway**. Every
   app from outside the Play Store gets this warning.
5. **Open Kodi** and let it finish its first-run setup.
6. **Live TV:** set up your PVR back end's client add-on, as described in
   [Before you start](#before-you-start-live-tv-needs-a-back-end) below. On
   your home network, or through a VPN to it, the back end's local address
   works the same as at home.

To check that AC-4 works: play an ATSC 3.0 channel, open the player's info
(the "i" button, or tap the screen and choose the info icon), and look for
**AC-4** as the audio codec.

**Android TV and Google TV:** these have no browser for downloading files.
Use an app such as **Downloader** (from the Play Store) to fetch the APK from
the Releases page, and allow it to install unknown apps when asked; or install
it from a PC with `adb install Kodi-21.3-AC4-arm64.apk` with developer
options and USB or network debugging turned on.

### Fire TV

Fire TV sticks run only 32-bit apps: use `Kodi-21.3-AC4-armv7.apk`.

1. **Install Downloader:** search for "Downloader" (by AFTVnews) in the Fire
   TV's app store and install it.
2. **Turn on Developer options** if they aren't showing: Settings > My Fire
   TV > About, select the device's name seven times, until it says you're a
   developer.
3. **Allow Downloader to install apps:** Settings > My Fire TV > Developer
   options > Install unknown apps > Downloader > On.
4. **Download and install:** in Downloader, enter
   `https://github.com/ferrellsl/kodi-ac4/releases/download/v21.3-ac4.3/Kodi-21.3-AC4-armv7.apk`
   and choose **Install** when it finishes. Afterwards Downloader offers to
   delete the APK, which saves space; Kodi stays installed.

Kodi then appears under Your Apps & Channels (the square icon on the home
screen).

**Updating:** the app doesn't update itself, since it isn't from the Play
Store. Install a newer APK the same way; it replaces the old one and keeps
your settings.

**Won't install?** "App not installed" or "There was a problem parsing the
package" usually means the wrong one of the two APKs. Fire TV sticks and many
older Android TV boxes run only 32-bit apps: use `Kodi-21.3-AC4-armv7.apk` on
those. Some recent phones run only 64-bit apps: use `Kodi-21.3-AC4-arm64.apk`.
An app such as CPU-Z (System tab, "Kernel Architecture") shows which a device
runs: aarch64 / arm64-v8a is 64-bit, armv7 / armeabi-v7a is 32-bit.

**Removing it:** Settings > Apps > Kodi (the one whose package is
`org.xbmc.kodiac4`) > Uninstall. This removes its settings too; the Play Store
Kodi isn't touched.

## Linux

`Kodi-21.3-AC4-x86_64.AppImage` is the whole of Kodi in one file: nothing is
installed, and it runs on most 64-bit distributions from 2022 or later (it
needs glibc 2.35 or newer: Ubuntu 22.04, Linux Mint 21, Debian 12, Fedora 36
and their successors).

1. Download it from the [Releases](../../releases) page.
2. Make it executable: right-click it > Properties > Permissions > "Allow
   executing file as program", or `chmod +x Kodi-21.3-AC4-x86_64.AppImage`.
3. Double-click it, or run `./Kodi-21.3-AC4-x86_64.AppImage`.

If it doesn't start and says something about FUSE, install your
distribution's FUSE 2 package (Ubuntu 22.04: `sudo apt install libfuse2`;
Ubuntu 24.04: `sudo apt install libfuse2t64`), or run it with
`--appimage-extract-and-run` after its name.

- **Its settings are kept in `~/.kodi-ac4`**, not `~/.kodi`, so it doesn't mix
  with a Kodi installed from your distribution. To have it use `~/.kodi`
  instead, start it with `KODI_DATA=~/.kodi`.
- **PVR clients are included**, because Kodi's add-on repository has none for
  Linux (distributions package them): NextPVR, TVHeadend, IPTV Simple Client
  and HDHomeRun, plus InputStream Adaptive and the joystick add-on. Enable the
  one you use under **Add-ons > My add-ons > PVR clients**.
- It uses the X11 display system; on a Wayland desktop it runs through
  XWayland, as most X11 programs do.

**So far this build has been tested only under WSL** (Windows Subsystem for
Linux, Ubuntu 22.04), **not on real Linux hardware**: there, AC-4 5.1 from an
ATSC 3.0 recording plays, Python works and add-ons install, using software
rendering (WSL's GPU drivers can't run Kodi). How it does with a real
graphics card and sound hardware is still unknown: please report how it works
for you, with your distribution and graphics card, in a
[GitHub issue](../../issues).

## Before you start: live TV needs a back end

This build adds an audio decoder to Kodi; it doesn't add a TV tuner. Kodi
plays ATSC 3.0 recordings and files on its own, but for **live TV** it needs
a PVR back end: a separate program that drives your tuner and hands the
channels to Kodi.

This build has been used with [NextPVR](https://www.nextpvr.com/) as the back
end and an HDHomeRun ATSC 3.0 tuner:

1. Install NextPVR (on the same PC or another one on your network), add your
   tuner in its settings, scan for channels, and check that a channel plays in
   NextPVR's own web player.
2. In Kodi, install the NextPVR client: **Add-ons > Install from repository >
   Kodi Add-on repository > PVR clients > NextPVR PVR Client**.
3. In the client's settings, enter the address of the PC running NextPVR
   (port 8866 by default) and its PIN, then restart Kodi. The channels appear
   under **TV**.

You'll need to be comfortable setting up NextPVR and Kodi's PVR add-ons
yourself. NextPVR's [documentation](https://github.com/sub3/NextPVR/wiki) and
[forum](https://forums.nextpvr.com/) cover the back end; Kodi's
[wiki](https://kodi.wiki/view/PVR) covers live TV in Kodi.

## Support

This build is shared as-is, for anyone it's useful to. I can't help with
installing or configuring Kodi, NextPVR, tuners, skins or add-ons: for those,
please use the [Kodi forum](https://forum.kodi.tv/) or the
[NextPVR forum](https://forums.nextpvr.com/). As an unofficial build, it isn't
supported by the Kodi team either, so please don't report problems with it to
them.

Problems with **AC-4 audio itself** (no sound, wrong channels, distortion on a
channel that plays fine elsewhere) are welcome as
[GitHub issues](../../issues): say which channel or file, and attach a short
recording if you can.

## What it plays

- AC-4 in MPEG-TS (ATSC 3.0 recordings and live TV, for example from an
  HDHomeRun), in MP4, and raw `.ac4` files.
- 5.1.4 Atmos broadcasts (channel-based), downmixed to 5.1 (new, see below).
- Mono, stereo and 5.1 AC-4, including 5.1 with parametric surrounds (A-CPL)
  and the high-frequency extension (A-SPX), as ATSC 3.0 broadcasters send it.
- Tested on stereo and 5.1 ATSC 3.0 broadcasts recorded from an HDHomeRun, and
  checked against Dolby's own decode of its test material (below).

## New in the third release (v21.3-ac4.3)

- **5.1.4 Atmos broadcasts now play.** Channel-based immersive AC-4 (5.1.4, as
  some ATSC 3.0 stations send it) used to play without sound. It is now decoded
  and downmixed to 5.1 by the AC-4 specification's rendering rules. Kodi gets
  5.1; there is no height output.
- **Regular stereo and 5.1 are unchanged:** bit-identical to the previous
  release on the test recordings.

How it was checked: a real 5.1.4 broadcast recording decodes from start to end
without errors. On Dolby's 5.1.4 test clip, the 5.1 output correlates 0.99 on
the fronts, 0.95-0.97 on center, LFE and surrounds with Dolby's own DD+ 5.1 of
the same program. The heights have had sanity checks only, as no reference
5.1.4 decode is available, and **this has not yet been heard on a live Atmos
station**, because none broadcasts in the developer's area. Reports from
markets with Atmos are welcome: please open an issue with your station and
what you hear.

## New in the second release (v21.3-ac4.2)

- **5.1 surrounds.** Much 5.1 on ATSC 3.0 is sent as left, right, center and
  LFE, the surrounds described by parameters for the decoder to rebuild
  (A-CPL). Earlier builds left the surrounds silent, and played the fronts
  about 6 dB too quietly, which made such 5.1 sound center-heavy, almost mono.
  The surrounds are now rebuilt as the AC-4 specification describes.
- **Full bandwidth in 5.1.** 5.1 stopped at about 14 kHz (the high-frequency
  extension, A-SPX, was applied to stereo only); it now has its top end.
- **Speed and pitch.** All earlier AC-4 builds played ATSC 3.0 audio about 4 %
  fast and 0.7 semitone sharp: the decoder skipped a resampling step the
  specification requires. Fixed. (The decoder now outputs 46034 Hz for ATSC
  3.0, which Kodi resamples like any other audio.)
- **Polarity.** All channels came out inverted; fixed.
- **An AC-4 badge.** Kodi's skin (Estuary) showed a question mark where the
  Dolby logo appears for Dolby Digital; it now shows "AC-4". Other skins have
  their own badges: for one that looks codec badges up as
  `flags/audiocodec/<codec>.png` (Estuary MOD V2 and others), copy
  `skin/estuary-modv2/ac4.png` (a bolder badge) or `skin/ac4.png` into the
  skin's `media\flags\audiocodec` folder (for an installed skin, under
  `%APPDATA%\Kodi\addons\<skin>\`) and restart Kodi. A skin update may remove
  it again.

How it was checked: Dolby's AC-4 Online Delivery Kit has the same program as
AC-4 5.1 and as Dolby Digital Plus 5.1. Against the DD+ decode, the AC-4 decode
now correlates 1.00 on the center channel, 0.91-0.96 on the fronts and LFE, and
0.64-0.70 on the rebuilt surrounds, with the same balance between channels;
the kit's channel-identification signal matches channel by channel, second by
second, within 1-2 dB.

## The channel fix (first release)

Earlier AC-4 builds of Kodi put the 5.1 and 7.1 channels in the wrong order:
the LFE (subwoofer) channel came out of the right surround speaker, and the
subwoofer got a surround channel. The decoder now puts the LFE fourth, where
FFmpeg and Kodi expect it (front left, front right, center, LFE, surrounds).

Also since the first release: **immersive AC-4 no longer crashes Kodi**, and ATSC 3.0's
subtitle stream (STPP) no longer shows up as a phantom 0-channel audio track.

## Known limitations

- **Object-based Atmos is not supported:** IMS and A-JOC streams, and some
  rarer modes, are rejected and play without sound; Kodi may show such a stream
  as "7.1". 5.1.4 and 7.1.4 channel-based streams play as 5.1; 7.1.4 with real
  back channels is implemented but no stream has tested it yet.
- **Rarer parametric-surround modes** (A-CPL in codec mode ASPX_ACPL_3, and in
  7.1) are not done yet: no broadcast or test material seen so far uses them.
- Windows 64-bit, Linux 64-bit (x86) and Android ARM (64- and 32-bit) only.

## Where the code is

The AC-4 support is one FFmpeg patch,
[`patches/0006-ffmpeg-ac4-decoder.patch`](patches/0006-ffmpeg-ac4-decoder.patch),
applied to the FFmpeg 6.0.1 that Kodi 21.3 builds. It contains Paul B Mahol's
AC-4 decoder and raw AC-4 demuxer, ported to the FFmpeg 6.0 API, with the
fixes above, and the hooks that make FFmpeg find AC-4 in MPEG-TS and MP4. The
FFmpeg tree it comes from is the branch
[`ffmpeg-6.0.1`](https://github.com/ferrellsl/ffmpeg-ac4/tree/ffmpeg-6.0.1) of
[ferrellsl/ffmpeg-ac4](https://github.com/ferrellsl/ffmpeg-ac4). Kodi itself
is unchanged: tag `21.3-Omega` of [xbmc/xbmc](https://github.com/xbmc/xbmc).

## Building it yourself

You need what Kodi's
[Windows build instructions](https://github.com/xbmc/xbmc/blob/21.3-Omega/docs/README.Windows.md)
list: Visual Studio 2022 with "Desktop development with C++", CMake, Git, Java
and NSIS. Use a folder with no spaces in its path.

```
git clone --depth 1 --branch 21.3-Omega https://github.com/xbmc/xbmc C:\Kodi-AC4\kodi
copy patches\0006-ffmpeg-ac4-decoder.patch C:\Kodi-AC4\kodi\tools\buildsteps\windows\patches\
copy skin\ac4.png C:\Kodi-AC4\kodi\addons\skin.estuary\media\flags\audiocodec\
cd C:\Kodi-AC4\kodi\tools\buildsteps\windows\x64
download-dependencies.bat
download-msys2.bat
make-mingwlibs.bat
make-addons.bat peripheral.joystick
BuildSetup.bat nobinaryaddons noprompt
```

Kodi's FFmpeg build (`make-mingwlibs.bat`) applies every `*-ffmpeg-*.patch` in
that folder, so the AC-4 patch goes in with Kodi's own. It opens a separate
MSYS2 window that waits for a key press when it finishes (`make-mingwlibs.bat
noprompt sh` runs it in the same window instead). The installer ends up in
`C:\Kodi-AC4\kodi\project\Win32BuildSetup`.

**Rebuilding with a newer patch:** Kodi rebuilds FFmpeg only when its own
build scripts change, and unpacks FFmpeg only once. Delete
`project\BuildDependencies\build\src\ffmpeg-6.0.1` and
`project\BuildDependencies\mingwlibs\x64\.last_success_revision` first, then run
`make-mingwlibs.bat` and `BuildSetup.bat` again.

### Android

[`android/build-android.sh`](android/build-android.sh) builds the Android APK
on Linux (tested on Ubuntu 22.04, also under WSL2). It needs what Kodi's
[Android build instructions](https://github.com/xbmc/xbmc/blob/21.3-Omega/docs/README.Android.md)
list: the packages named at the top of the script (with Java 17), and the
Android command-line tools with NDK r21e (`ndk;21.4.7075529`), the NDK Kodi 21
is released with. The script clones Kodi 21.3, adds the AC-4 patch to Kodi's
FFmpeg 6.0.1 build (Kodi's Android build doesn't apply FFmpeg patches by
itself, so it adds that step), builds the dependencies, Kodi and the APK, and
signs it. With no signing key given, it makes one and keeps it; sign later
builds with the same key, or Android won't install them over the earlier one.
The first build takes about an hour on a 16-core PC. `ARCH=arm` builds the
32-bit APK for Fire TV. Settings are described at the top of the script.

### Linux

[`linux/build-appimage.sh`](linux/build-appimage.sh) builds the AppImage on
Ubuntu 22.04 (also under WSL2), after the build dependencies listed in Kodi's
[Ubuntu build instructions](https://github.com/xbmc/xbmc/blob/21.3-Omega/docs/README.Ubuntu.md)
(section 3.2) and the few more named at the top of the script. It clones Kodi
21.3, adds a step to Kodi's internal FFmpeg build that applies the AC-4 patch,
builds Kodi (X11, OpenGL) and the PVR add-ons, adds Python's standard library
and packages it all with linuxdeploy. About 40 minutes on a 16-core PC.

`skin/ac4.png` is the skin's AC-4 codec badge, made by `skin/make_ac4_flag.py`
from the skin's AAC badge, with Noto Sans (SIL Open Font License);
`skin/estuary-modv2/ac4.png`, the bolder one, by `skin/make_ac4_flag_bold.py`.

`kodi-step.bat` runs one of those steps (for example
`kodi-step.bat make-mingwlibs.bat`) from any shell. It's only needed where the
environment variable `NoDefaultCurrentDirectoryInExePath` is set, because
Kodi's scripts call each other by bare name. Edit the path in it if your clone
isn't in `C:\Kodi-AC4\kodi`.

## License

Kodi and FFmpeg are GPL; this build and the patch are under the same terms.
Kodi® is a trademark of the XBMC Foundation; this is an unofficial build, not
supported by the Kodi team.

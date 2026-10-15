# Kodi 21.3 "Omega" with AC-4 audio

Kodi 21.3 for Windows (64-bit) that plays **AC-4 audio**, the Dolby format used by
ATSC 3.0 ("NextGen TV") broadcasts, some DVB services and streaming. Stock Kodi
can't decode AC-4, so NextGen channels play without sound.

**Download:** the installer is on the [Releases](../../releases) page
(`Kodi-21.3-AC4-x64-setup.exe`). It installs like the official Kodi 21.3 and
replaces an existing Kodi 21 installation; your settings and library are kept.

## What it plays

- AC-4 in MPEG-TS (ATSC 3.0 recordings and live TV, for example from an
  HDHomeRun), in MP4, and raw `.ac4` files.
- Mono, stereo, 5.1 and 7.1 AC-4. Tested on 5.1 and stereo ATSC 3.0
  broadcasts recorded from an HDHomeRun.

## The channel fix

Earlier AC-4 builds of Kodi put the 5.1 and 7.1 channels in the wrong order:
the LFE (subwoofer) channel came out of the right surround speaker, and the
subwoofer got a surround channel. The decoder kept the LFE after the main
channels, where FFmpeg and Kodi expect it fourth (front left, front right,
center, LFE, surrounds). This build reorders the output, so the LFE goes to the
subwoofer. This was checked on 5.1 ATSC 3.0 broadcasts: the LFE is output
channel 4.

## Other changes from earlier AC-4 builds

- **Immersive AC-4 no longer crashes Kodi.** Streams using immersive audio
  (IMS, A-JOC / Atmos) made the decoder write past its buffers and crash. Those
  frames are now rejected as invalid data instead. Immersive AC-4 is still not
  supported, but playback no longer brings Kodi down.
- **No phantom audio track.** ATSC 3.0 broadcasts carry a subtitle stream
  (STPP) that was listed as an extra AC-4 audio track with 0 channels; it is
  now treated as data.
- Based on Kodi 21.3 and its FFmpeg 6.0.1 (earlier builds were Kodi 19/20 on
  FFmpeg 4.3).

## Known limitations

- **Surround channels coded parametrically (A-CPL) are not rebuilt.** Much 5.1
  on ATSC 3.0 is sent as left, right, center and LFE, with the surrounds
  described by parameters for the receiver to reconstruct. The decoder reads
  those parameters but does not reconstruct the surrounds, so in such streams
  the two surround channels are silent. (The 5.1 stations tested here all use
  it.)
- **A-SPX (the high-frequency extension) is applied only to mono and
  stereo**, so 5.1 streams that use it have a reduced top end.
- **Immersive AC-4 (IMS, A-JOC / Atmos) is not supported** (see above).
- Windows 64-bit only.

## Where the code is

The AC-4 support is one FFmpeg patch,
[`patches/0006-ffmpeg-ac4-decoder.patch`](patches/0006-ffmpeg-ac4-decoder.patch),
applied to the FFmpeg 6.0.1 that Kodi 21.3 builds. It contains Paul B Mahol's
AC-4 decoder and raw AC-4 demuxer, ported from the FFmpeg 4.3 tree in
[ferrellsl/ffmpeg-ac4](https://github.com/ferrellsl/ffmpeg-ac4) to the FFmpeg
6.0 API, with the fixes above, and the hooks that make FFmpeg find AC-4 in
MPEG-TS and MP4. Kodi itself is unchanged: tag `21.3-Omega` of
[xbmc/xbmc](https://github.com/xbmc/xbmc).

## Building it yourself

You need what Kodi's
[Windows build instructions](https://github.com/xbmc/xbmc/blob/21.3-Omega/docs/README.Windows.md)
list: Visual Studio 2022 with "Desktop development with C++", CMake, Git, Java
and NSIS. Use a folder with no spaces in its path.

```
git clone --depth 1 --branch 21.3-Omega https://github.com/xbmc/xbmc C:\Kodi-AC4\kodi
copy patches\0006-ffmpeg-ac4-decoder.patch C:\Kodi-AC4\kodi\tools\buildsteps\windows\patches\
cd C:\Kodi-AC4\kodi\tools\buildsteps\windows\x64
download-dependencies.bat
download-msys2.bat
make-mingwlibs.bat
make-addons.bat peripheral.joystick
BuildSetup.bat nobinaryaddons noprompt
```

Kodi's FFmpeg build (`make-mingwlibs.bat`) applies every `*-ffmpeg-*.patch` in
that folder, so the AC-4 patch goes in with Kodi's own. It opens a separate
MSYS2 window that waits for a key press when it finishes. The installer ends up
in `C:\Kodi-AC4\kodi\project\Win32BuildSetup`.

`kodi-step.bat` runs one of those steps (for example
`kodi-step.bat make-mingwlibs.bat`) from any shell. It's only needed where the
environment variable `NoDefaultCurrentDirectoryInExePath` is set, because
Kodi's scripts call each other by bare name. Edit the path in it if your clone
isn't in `C:\Kodi-AC4\kodi`.

## License

Kodi and FFmpeg are GPL; this build and the patch are under the same terms.
Kodi® is a trademark of the XBMC Foundation; this is an unofficial build, not
supported by the Kodi team.

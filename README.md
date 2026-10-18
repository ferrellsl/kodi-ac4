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
- Mono, stereo and 5.1 AC-4, including 5.1 with parametric surrounds (A-CPL)
  and the high-frequency extension (A-SPX), as ATSC 3.0 broadcasters send it.
- Tested on stereo and 5.1 ATSC 3.0 broadcasts recorded from an HDHomeRun, and
  checked against Dolby's own decode of its test material (below).

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

Also since the first release: **immersive AC-4 no longer crashes Kodi** (such
frames are rejected; immersive audio is still not supported), and ATSC 3.0's
subtitle stream (STPP) no longer shows up as a phantom 0-channel audio track.

## Known limitations

- **Immersive AC-4 is not supported**: IMS / A-JOC (Atmos) and channel
  configurations with height speakers such as 5.1.4. Kodi may show such a
  stream as "7.1"; it plays without sound.
- **Rarer parametric-surround modes** (A-CPL in codec mode ASPX_ACPL_3, and in
  7.1) are not done yet: no broadcast or test material seen so far uses them.
- Windows 64-bit only.

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

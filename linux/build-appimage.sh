#!/bin/bash
# Kodi 21.3 "Omega" for Linux (x86_64) with AC-4 audio, as an AppImage.
#
# Run on Ubuntu 22.04 (also under WSL2) from this repository's linux folder. The AppImage then runs
# on distributions at least as new (glibc 2.35 or later). First install Kodi's build dependencies
# (docs/README.Ubuntu.md in Kodi's source, section 3.2) plus: libcec-dev liblirc-dev libdav1d-dev
# file patchelf desktop-file-utils libfuse2.
#
# Settings (environment variables):
#   WORK     where Kodi, the build and the AppDir go (default ~/linux-kodi)
#   ADDONS   the binary add-ons to include (Kodi's add-on repository has none for Linux; distributions
#            package them): default PVR clients for NextPVR, TVHeadend, IPTV Simple and HDHomeRun,
#            plus inputstream.adaptive and peripheral.joystick
#
# The AppImage ends up in $WORK as Kodi-21.3-AC4-x86_64.AppImage.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
WORK=${WORK:-$HOME/linux-kodi}
ADDONS=${ADDONS:-"pvr.nextpvr pvr.hts pvr.iptvsimple pvr.hdhomerun inputstream.adaptive peripheral.joystick"}
APPDIR=$WORK/AppDir
JOBS=$(nproc)
mkdir -p "$WORK"
cd "$WORK"

# Kodi 21.3, with the AC-4 patch applied to the FFmpeg 6.0.1 Kodi builds itself
[ -d kodi ] || git clone --depth 1 --branch 21.3-Omega https://github.com/xbmc/xbmc kodi
cd kodi
cp "$HERE/../patches/0006-ffmpeg-ac4-decoder.patch" tools/depends/target/ffmpeg/
grep -q 0006-ffmpeg-ac4 cmake/modules/FindFFMPEG.cmake || \
  sed -i 's#^\(                    \)<SOURCE_DIR>)$#\1<SOURCE_DIR>\n\1COMMAND patch -p1 -d <SOURCE_DIR> -i ${CMAKE_SOURCE_DIR}/tools/depends/target/ffmpeg/0006-ffmpeg-ac4-decoder.patch)#' \
    cmake/modules/FindFFMPEG.cmake
grep -q 0006-ffmpeg-ac4 cmake/modules/FindFFMPEG.cmake
cp "$HERE/../skin/ac4.png" addons/skin.estuary/media/flags/audiocodec/ac4.png

# Kodi (X11; it runs under Wayland desktops through XWayland)
mkdir -p "$WORK/build" && cd "$WORK/build"
cmake ../kodi -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib \
  -DCORE_PLATFORM_NAME=x11 -DAPP_RENDER_SYSTEM=gl -DENABLE_INTERNAL_FFMPEG=ON \
  -DENABLE_INTERNAL_FLATBUFFERS=ON -DENABLE_TESTING=OFF
cmake --build . -- -j"$JOBS"
rm -rf "$APPDIR"
DESTDIR="$APPDIR" cmake --install .

# the binary add-ons, built against the Kodi just installed in the AppDir (pvr.iptvsimple wants
# zlib 1.3.1 from zlib.net, which no longer has it: the same file comes from zlib's GitHub release)
cd "$WORK/kodi"
make -C tools/depends/target/binary-addons clean >/dev/null 2>&1 || true
mkdir -p tools/depends/target/binary-addons/native/build/download
curl -sSLo tools/depends/target/binary-addons/native/build/download/zlib-1.3.1.tar.xz \
  https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.xz
make -j"$JOBS" -C tools/depends/target/binary-addons PREFIX="$APPDIR/usr" ADDONS="$ADDONS"
for a in $ADDONS; do
  [ -d "$APPDIR/usr/lib/kodi/addons/$a" ] || { echo "add-on $a was not built"; exit 1; }
done

# Python's standard library (Kodi embeds the system's Python)
PY=$(python3 -c 'import sys; print("python%d.%d" % sys.version_info[:2])')
mkdir -p "$APPDIR/usr/lib/$PY"
(cd /usr/lib/$PY && tar --exclude=./test --exclude=./site-packages --exclude=./dist-packages \
  --exclude='__pycache__' -cf - .) | tar -xf - -C "$APPDIR/usr/lib/$PY"

# what starts it: Kodi's files are found through its KODI_* variables, and its settings are kept
# in ~/.kodi-ac4 (not ~/.kodi, which another Kodi may be using) unless KODI_DATA says otherwise
BIN=$(cd "$APPDIR/usr/lib/kodi" && ls kodi-x11 kodi.bin 2>/dev/null | head -1)
[ -n "$BIN" ] || { echo "no Kodi binary in $APPDIR/usr/lib/kodi"; exit 1; }
cat > "$WORK/AppRun" <<EOF
#!/bin/sh
HERE="\$(dirname "\$(readlink -f "\$0")")"
export KODI_HOME="\$HERE/usr/share/kodi"
export KODI_BIN_HOME="\$HERE/usr/lib/kodi"
export KODI_BINADDON_PATH="\$HERE/usr/lib/kodi/addons"
export KODI_DATA="\${KODI_DATA:-\$HOME/.kodi-ac4}"
export PYTHONHOME="\$HERE/usr"
export PATH="\$HERE/usr/lib/kodi:\$PATH"
exec "\$HERE/usr/lib/kodi/$BIN" "\$@"
EOF
chmod +x "$WORK/AppRun"
sed -i 's/^Name=Kodi$/Name=Kodi (AC-4)/' "$APPDIR/usr/share/applications/kodi.desktop"

# the libraries it needs, then the AppImage
cd "$WORK"
[ -x linuxdeploy-x86_64.AppImage ] || {
  curl -sSLo linuxdeploy-x86_64.AppImage \
    https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
  chmod +x linuxdeploy-x86_64.AppImage
}
EXTRA=()
for f in "$APPDIR/usr/lib/kodi/kodi-xrandr"; do [ -f "$f" ] && EXTRA+=(--executable "$f"); done
export APPIMAGE_EXTRACT_AND_RUN=1 NO_STRIP=1 LDAI_OUTPUT=Kodi-21.3-AC4-x86_64.AppImage
./linuxdeploy-x86_64.AppImage --appdir "$APPDIR" \
  --executable "$APPDIR/usr/lib/kodi/$BIN" "${EXTRA[@]}" \
  --deploy-deps-only "$APPDIR/usr/lib/kodi/addons" \
  --deploy-deps-only "$APPDIR/usr/lib/$PY/lib-dynload" \
  --desktop-file "$APPDIR/usr/share/applications/kodi.desktop" \
  --icon-file "$APPDIR/usr/share/icons/hicolor/256x256/apps/kodi.png" \
  --custom-apprun "$WORK/AppRun" \
  --output appimage
ls -la "$WORK/Kodi-21.3-AC4-x86_64.AppImage"

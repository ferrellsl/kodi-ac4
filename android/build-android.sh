#!/bin/bash
# Kodi 21.3 "Omega" for Android (64-bit ARM, or 32-bit ARM for Fire TV) with AC-4 audio.
#
# Run on Linux (tested on Ubuntu 22.04, also under WSL2) from this repository's
# android folder, after installing what Kodi's docs/README.Android.md lists:
#   sudo apt install autoconf bison build-essential curl openjdk-17-jdk-headless flex gawk git \
#     gperf lib32stdc++6 lib32z1 lib32z1-dev libcurl4-openssl-dev unzip zip zlib1g-dev
# and the Android command-line tools, with:
#   sdkmanager platform-tools "platforms;android-34" "build-tools;33.0.1" "ndk;21.4.7075529"
#
# Settings (environment variables):
#   ARCH          arm64 (the default: phones and tablets) or arm (32-bit: Fire TV sticks and
#                 older Android TV boxes)
#   ANDROID_SDK   the SDK folder (default ~/android-tools/android-sdk-linux)
#   WORK          where Kodi, its dependencies and the build go (default ~/android-tools)
#   APP_PACKAGE   the app's package name (default org.xbmc.kodiac4, so it installs beside the
#                 Play Store Kodi instead of replacing it)
#   KODI_ANDROID_STORE_FILE, KODI_ANDROID_STORE_PASSWORD, KODI_ANDROID_KEY_ALIAS,
#   KODI_ANDROID_KEY_PASSWORD   the signing key; when unset, one is made in $WORK/signing and
#                 kept there (later builds must be signed with the same key to install as updates)
#
# The APK ends up in $WORK/kodi as kodiapp-arm64-v8a-release.apk (ARCH=arm:
# kodiapp-armeabi-v7a-release.apk).
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
WORK=${WORK:-$HOME/android-tools}
SDK=${ANDROID_SDK:-$WORK/android-sdk-linux}
NDK=$SDK/ndk/21.4.7075529
APP_PACKAGE=${APP_PACKAGE:-org.xbmc.kodiac4}
case "${ARCH:-arm64}" in
  arm64) HOST=aarch64-linux-android; ABI=arm64-v8a; BUILD=$WORK/kodi-build ;;
  arm) HOST=arm-linux-androideabi; ABI=armeabi-v7a; BUILD=$WORK/kodi-build-arm ;;
  *) echo "ARCH must be arm64 or arm"; exit 1 ;;
esac
export JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}
mkdir -p "$WORK/xbmc-tarballs"
cd "$WORK"

# Kodi 21.3, with the AC-4 patch applied when the dependency build unpacks FFmpeg 6.0.1
[ -d kodi ] || git clone --depth 1 --branch 21.3-Omega https://github.com/xbmc/xbmc kodi
cd kodi
cp "$HERE/../patches/0006-ffmpeg-ac4-decoder.patch" tools/depends/target/ffmpeg/
grep -q 0006-ffmpeg-ac4 tools/depends/target/ffmpeg/Makefile || \
  sed -i 's#^\tcd $(PLATFORM); cp ../CMakeLists.txt ./#\tcd $(PLATFORM); patch -p1 -i ../0006-ffmpeg-ac4-decoder.patch\n&#' \
    tools/depends/target/ffmpeg/Makefile
cp "$HERE/../skin/ac4.png" addons/skin.estuary/media/flags/audiocodec/ac4.png
sed -i "s/^APP_PACKAGE .*/APP_PACKAGE $APP_PACKAGE/" version.txt

# the dependencies, release build (the default is a debug build). Configured for this ARCH each
# time; what was built before for it is kept.
cd tools/depends
./bootstrap
./configure --with-tarballs="$WORK/xbmc-tarballs" --host=$HOST \
  --with-sdk-path="$SDK" --with-ndk-path="$NDK" --prefix="$WORK/xbmc-depends" --enable-debug=no
make -j"$(nproc)"
cd "$WORK/kodi"
make -j"$(nproc)" -C tools/depends/target/binary-addons ADDONS="peripheral.joystick"

# Kodi
mkdir -p "$BUILD" && cd "$BUILD"
cmake "$WORK/kodi" -DCMAKE_TOOLCHAIN_FILE="$WORK/xbmc-depends/$HOST-21-release/share/Toolchain.cmake"
cmake --build . -- -j"$(nproc)"

# the signing key, then the APK
if [ -z "$KODI_ANDROID_STORE_FILE" ]; then
  K=$WORK/signing
  if [ ! -f "$K/signing.env" ]; then
    mkdir -p "$K"; chmod 700 "$K"
    PW=$(head -c 24 /dev/urandom | base64 | tr -d '/+=' | head -c 24)
    keytool -genkeypair -keystore "$K/kodiac4.keystore" -alias kodiac4 -keyalg RSA -keysize 2048 \
      -validity 10000 -dname "CN=Kodi AC-4 build" -storepass "$PW" -keypass "$PW"
    printf 'export KODI_ANDROID_STORE_FILE=%s\nexport KODI_ANDROID_STORE_PASSWORD=%s\nexport KODI_ANDROID_KEY_ALIAS=kodiac4\nexport KODI_ANDROID_KEY_PASSWORD=%s\n' \
      "$K/kodiac4.keystore" "$PW" "$PW" > "$K/signing.env"
    chmod 600 "$K/signing.env" "$K/kodiac4.keystore"
  fi
  . "$K/signing.env"
fi
make apk
ls -la "$WORK/kodi/kodiapp-$ABI-release.apk"

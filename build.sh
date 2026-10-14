#!/bin/bash
set -eu
cd "$(dirname "$0")"
APP="$PWD/dist/DigiRust.app"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" build
cp Resources/* "$APP/Contents/Resources/"
xcrun swiftc -swift-version 5 Sources/Brand.swift Artwork/render_icon.swift -o build/render-icon
build/render-icon build/DigiRust.png
mkdir -p build/DigiRust.iconset
for size in 16 32 128 256 512; do
  sips -z "$size" "$size" build/DigiRust.png --out "build/DigiRust.iconset/icon_${size}x${size}.png" >/dev/null
  doubled=$((size * 2))
  sips -z "$doubled" "$doubled" build/DigiRust.png --out "build/DigiRust.iconset/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns build/DigiRust.iconset -o "$APP/Contents/Resources/DigiRust.icns"
for arch in arm64 x86_64; do
  xcrun clang -arch "$arch" -mmacosx-version-min=11.0 -O2 -std=c11 Vendor/elektron-firmware-tool/*.c -o "build/tool-$arch"
done
xcrun lipo -create build/tool-arm64 build/tool-x86_64 -output "$APP/Contents/Resources/elektron-firmware-tool"
codesign --force --sign - "$APP/Contents/Resources/elektron-firmware-tool"
BACKEND_HASH=$(shasum -a 256 "$APP/Contents/Resources/elektron-firmware-tool" | cut -d ' ' -f 1)
printf 'let backendPin = "%s"\n' "$BACKEND_HASH" > Sources/BackendPin.swift
for arch in arm64 x86_64; do
  xcrun swiftc -swift-version 5 -O -target "$arch-apple-macos11.0" Sources/*.swift -o "build/app-$arch"
done
xcrun lipo -create build/app-arm64 build/app-x86_64 -output "$APP/Contents/MacOS/DigiRust"
cp Vendor/elektron-firmware-tool/LICENSE "$APP/Contents/Resources/elektron-firmware-tool-LICENSE.txt"
cp Vendor/elektron-firmware-tool/PROVENANCE.md "$APP/Contents/Resources/tool-provenance.md"
cp NOTICE.md "$APP/Contents/Resources/NOTICE.md"
cp LICENSE "$APP/Contents/Resources/LICENSE"
cp DISCLAIMER.md "$APP/Contents/Resources/DISCLAIMER.md"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>DigiRust</string>
<key>CFBundleIconFile</key><string>DigiRust</string>
<key>CFBundleIdentifier</key><string>app.digirust.patcher</string>
<key>CFBundleName</key><string>DigiRust</string>
<key>CFBundleDisplayName</key><string>DigiRust</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>1.2.0</string>
<key>CFBundleVersion</key><string>1</string>
<key>LSMinimumSystemVersion</key><string>11.0</string>
<key>NSHighResolutionCapable</key><true/>
<key>NSHumanReadableCopyright</key><string>DigiRust. Unofficial; not affiliated with Elektron.</string>
</dict></plist>
PLIST
codesign --force --sign - "$APP"
codesign --verify --deep --strict "$APP"
echo "Built universal macOS application: $APP"

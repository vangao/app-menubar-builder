#!/usr/bin/env bash
set -euo pipefail

APP_NAME="NewOfficeFile"
BUNDLE_ID="local.newofficefile"

APP_DIR="$(pwd)/${APP_NAME}.app"
MACOS_DIR="${APP_DIR}/Contents/MacOS"
RES_DIR="${APP_DIR}/Contents/Resources"
PLIST="${APP_DIR}/Contents/Info.plist"

echo "Building ${APP_NAME}.app ..."

rm -rf "${APP_DIR}"
mkdir -p "${MACOS_DIR}" "${RES_DIR}"

echo "Compiling Swift binary..."
swiftc -O -framework AppKit src/main.swift -o "${MACOS_DIR}/${APP_NAME}"
chmod +x "${MACOS_DIR}/${APP_NAME}"

echo "Writing Info.plist..."
cat >"${PLIST}" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>2.0</string>
    <key>CFBundleVersion</key>
    <string>2</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSAppleEventsUsageDescription</key>
    <string>Used to read the front Finder window path and show dialogs.</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
PLIST

# Copy icon if available
if [[ -f "NewOfficeFileIcon.png" ]]; then
    echo "Generating icon..."
    # Create minimal icns from PNG
    python3 - <<'PY'
import struct
with open('NewOfficeFileIcon.png', 'rb') as f:
    data = f.read()
entry_type = b'ic10'
entry_size = 8 + len(data)
total_size = 8 + entry_size
with open('AppIcon.icns', 'wb') as out:
    out.write(b'icns')
    out.write(struct.pack('>I', total_size))
    out.write(entry_type)
    out.write(struct.pack('>I', entry_size))
    out.write(data)
PY
    mv AppIcon.icns "${RES_DIR}/AppIcon.icns"
    echo "Icon added."
fi

echo "Done: ${APP_DIR}"
echo ""
echo "To install, run:"
echo "  cp -R ${APP_NAME}.app /Applications/"

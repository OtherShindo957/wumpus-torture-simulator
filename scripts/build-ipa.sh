#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ "$(uname -s)" != Darwin ]]; then
  echo 'IPA compilation requires macOS with Xcode. Use the GitHub Actions workflow.' >&2
  exit 1
fi
npm run build:ios-web
APP="$PWD/build/ipa/Payload/Wumpus.app"
mkdir -p "$APP"
cp ios/Info.plist "$APP/Info.plist"
cp -R build/web "$APP/"
SDK="$(xcrun --sdk iphoneos --show-sdk-path)"
xcrun --sdk iphoneos swiftc ios/App.swift -parse-as-library -O \
  -sdk "$SDK" -target arm64-apple-ios16.0 \
  -framework UIKit -framework WebKit \
  -Xlinker -rpath -Xlinker /usr/lib/swift \
  -o "$APP/Wumpus"
plutil -lint "$APP/Info.plist"
# Deliberately no developer certificate or provisioning profile.
# The sideloading application must sign this package before installation.
file "$APP/Wumpus"
mkdir -p dist
rm -f dist/Wumpus-unsigned.ipa
(cd build/ipa && /usr/bin/zip -qry ../../dist/Wumpus-unsigned.ipa Payload)
unzip -t dist/Wumpus-unsigned.ipa
printf '\nCreated dist/Wumpus-unsigned.ipa (must be signed by a sideloading tool).\n'

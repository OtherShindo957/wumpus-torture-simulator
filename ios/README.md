# Wumpus for sideloading

This wraps the original game in WKWebView and bundles Three.js and Rapier (including its embedded WebAssembly) into the app. Requires iOS/iPadOS 16 or newer on an arm64 device. The game runs locally; its optional GitHub star-count request still uses the network. The development screenshot endpoint is unavailable inside the app.

## Get the IPA with GitHub Actions

1. Push the `ios-sideload` branch to your fork. The **Build sideload IPA** workflow runs automatically. If Actions are disabled on the fork, enable them and re-run the workflow.
2. Open the repository's **Actions** tab, then the completed build.
3. Download **Wumpus-unsigned-IPA** from Artifacts and extract the ZIP.
4. Import **Wumpus-unsigned.ipa** into your sideloading application (for example AltStore or Sideloadly) and follow its signing/install process. Use your own Apple account in that tool, never in this repository or GitHub secrets.

This package is unsigned: downloading it alone does not install it. Signing validity, refresh requirements, and device limits depend on the chosen signing method.

## Build on your own Mac

Install full Xcode, select it as the active developer directory, and install Node.js 22. From the repository root:

```sh
npm ci --ignore-scripts --no-audit --no-fund
bash scripts/build-ipa.sh
```

Output: `dist/Wumpus-unsigned.ipa`. No paid developer membership or signing credentials are needed to compile this unsigned package. Signing is a separate step.

## Validation

The web bundler can run on Linux; native compilation requires Apple's iPhoneOS SDK on macOS. Successful compilation does not establish on-device performance. Verify touch dragging, audio after a tap, rotation, save persistence, and a fresh offline launch on the target device after sideloading. The app currently uses the default icon.

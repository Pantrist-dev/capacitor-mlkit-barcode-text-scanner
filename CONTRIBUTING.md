# Contributing

## Setup

```bash
npm install
```

## Build and check

- `npm run build`: compiles the web part and regenerates the API section of the README from the JSDoc in `src/definitions.ts`. Do not edit that section by hand.
- `npm run lint`: ESLint, Prettier and SwiftLint. `npm run fmt` fixes what it can.
- `npm run verify:android`: builds and tests the Android library.
- `npm run verify:ios`: installs the pods and builds the iOS framework.

## Changes from the original plugin

This repository is a fork of [`@capacitor-mlkit/barcode-scanning`](https://github.com/capawesome-team/capacitor-mlkit/tree/main/packages/barcode-scanning) and keeps its history. To take over a fix from there, add the original as a remote and cherry-pick the commit:

```bash
git remote add capawesome https://github.com/capawesome-team/capacitor-mlkit.git
git fetch capawesome main
git subtree split --prefix=packages/barcode-scanning capawesome/main -b capawesome-barcode-scanning
git cherry-pick <commit>
```

Keep the native plugin name `BarcodeScanner` and the class names of the original, so the plugin stays a drop-in replacement and fixes from the original apply cleanly.

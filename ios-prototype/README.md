# Quick Pane native launch prototype

This is an isolated proof-of-concept. It does not change the existing GitHub Pages web app.

## Goal

Test whether an iPhone app containing Quick Pane can appear as a Camera Control launch target by adopting Apple's `LockedCameraCapture` framework, then hand off to the native app's `WKWebView`.

- Main app: opens `https://udonrx.github.io/quick-pane/`.
- Capture extension: uses Apple's `com.apple.securecapture` extension point and an actual camera picker, because iOS terminates capture extensions that don't provide an active camera experience.
- Experimental behavior: when the capture extension appears, it tries to call `LockedCameraCaptureSession.openApplication(for:)` automatically. Apple documents this transition as interaction-driven, so iOS may reject the automatic attempt. A visible button is included as a fallback.

## Important limitations

1. Apple's capture extension cannot access the network. The web page is loaded only after the containing app opens; the extension itself cannot load Quick Pane from the internet.
2. This is a test build, not a guaranteed solution. The app is a web wrapper, not a full camera app. Whether iOS 27 will show it in Settings > Camera > Camera Control and accept the automatic handoff must be tested on the actual iPhone 17.
3. The build workflow produces an **unsigned** IPA. An unsigned IPA cannot be installed directly on an iPhone.
4. Apple's free Personal Team provisioning requires Xcode and periodically expires (Apple documents a 7-day provisioning lifetime). A GitHub-hosted build runner can compile the app, but it cannot sign it as the user's free Personal Team without the necessary Apple account/device setup.
5. No computer-free, free, official installation/signing route for Japan was verified. Do not install unknown enterprise certificates or share Apple account credentials with third-party signing websites.

## Build

The GitHub Actions workflow `.github/workflows/build-quick-pane-native.yml` builds an unsigned IPA on a GitHub-hosted macOS runner and uploads it as an artifact. Run it from the Actions tab on the `ios-native-prototype` branch.

After downloading the artifact, a separate signing/install path is still required before the iPhone can test it.

## References

- Apple Camera Control: https://developer.apple.com/documentation/AVFoundation/enhancing-your-app-experience-with-the-camera-control
- Apple LockedCameraCapture: https://developer.apple.com/documentation/LockedCameraCapture/Creating-a-camera-experience-for-the-Lock-Screen
- Apple's free Personal Team limitations: https://developer.apple.com/help/account/basics/about-your-developer-account

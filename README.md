# tropayment-ios

Official native **tropayment Merchant** iOS application (SwiftUI).

Repository layout:

```text
.github/workflows/ios-build.yml
TropaymentMerchant/
  TropaymentMerchant.xcodeproj
  TropaymentMerchant/          # Swift source
  README.md
```

## Quick start (macOS)

```bash
cd TropaymentMerchant
open TropaymentMerchant.xcodeproj
```

## CI

Every push to `main` runs **GitHub Actions** on `macos-15` with **Xcode 16.4** and builds for the **iOS Simulator** without code signing.

See [TropaymentMerchant/README.md](TropaymentMerchant/README.md) for details.

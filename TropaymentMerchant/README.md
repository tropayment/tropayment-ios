# tropayment Merchant — iOS

Native SwiftUI merchant application for iPhone and iPad.

## Requirements

- macOS with **Xcode 16+**
- iOS **16.0+** deployment target
- Apple Developer account (for device testing and App Store)

## Open the project

```bash
cd TropaymentMerchant
open TropaymentMerchant.xcodeproj
```

Or double-click `TropaymentMerchant.xcodeproj` in Finder.

## Build (local macOS)

```bash
cd TropaymentMerchant
xcodebuild \
  -project TropaymentMerchant.xcodeproj \
  -scheme TropaymentMerchant \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  build
```

Set your **Development Team** in Signing & Capabilities before running on a physical device.

## CI (GitHub Actions)

Pushes to `main` run a real `xcodebuild` on `macos-15` with **Xcode 16.4** — see [`.github/workflows/ios-build.yml`](../.github/workflows/ios-build.yml).

## Configuration

| Environment | API base URL |
|-------------|------------|
| Production | `https://api.tropayment.com/api` |
| Staging | `https://staging-api.tropayment.com/api` |
| Debug override | Set env `TROPAYMENT_API_BASE` in Xcode scheme |

Authentication uses **Laravel Sanctum** Bearer tokens stored in the **Keychain**.

See [`IOS_API_REQUIREMENTS.md`](IOS_API_REQUIREMENTS.md) if present, or the main tropayment docs repo.

## Phase 1 (current)

- Xcode project + MVVM architecture
- Design system (Tropayment brand colors)
- APIClient + Keychain + AuthService
- Login, 2FA, forgot password
- Session bootstrap via `GET /v1/me`
- Tab placeholders for Dashboard, Payments, Transactions, Wallet, Settings

## Regenerate Xcode project

If you add Swift files, update `generate_xcode_project.py` and run:

```bash
python3 generate_xcode_project.py
```

## Notes

- This is **not** a WebView wrapper — all primary UI is SwiftUI.
- Windows developers: rely on GitHub Actions for compile verification.

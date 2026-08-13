# tropayment Merchant — iOS

Native SwiftUI merchant application for iPhone and iPad.

## Requirements

- macOS with **Xcode 16+**
- iOS **16.0+** deployment target
- Apple Developer account (for device testing and App Store)

## Open the project

```bash
open ios/TropaymentMerchant/TropaymentMerchant.xcodeproj
```

Or double-click `TropaymentMerchant.xcodeproj` in Finder.

## Build

```bash
cd ios/TropaymentMerchant
xcodebuild -scheme TropaymentMerchant -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Set your **Development Team** in Signing & Capabilities before running on a physical device.

## Configuration

| Environment | API base URL |
|-------------|------------|
| Production | `https://api.tropayment.com/api` |
| Staging | `https://staging-api.tropayment.com/api` |
| Debug override | Set env `TROPAYMENT_API_BASE` in Xcode scheme |

Authentication uses **Laravel Sanctum** Bearer tokens stored in the **Keychain**.

See [`../../others/mobile/IOS_API_REQUIREMENTS.md`](../../others/mobile/IOS_API_REQUIREMENTS.md) for API details.

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
- Build verification requires macOS; the repo was scaffolded on Windows and must be built on a Mac with Xcode.

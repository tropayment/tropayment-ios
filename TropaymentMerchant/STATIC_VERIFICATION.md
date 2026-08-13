# Phase 1 — Static Verification Report

**Date:** Generated during pre-Phase 2 review  
**Environment:** Windows (no Xcode / Swift toolchain)  
**Compilation:** **NOT VERIFIED** — requires macOS + Xcode 16+

---

## Summary

| Category | Result |
|----------|--------|
| Project structure | ✅ 33/33 Swift files in target |
| Static code review | ✅ Issues found and fixed (see below) |
| Xcode build | ⏳ Pending Mac verification |
| Ready for Xcode build | ✅ **Yes** (with Mac-only items below) |

---

## Verification Checklist (30 items)

### 1. Xcode project structure / pbxproj
- ✅ Single target `TropaymentMerchant`
- ✅ 33 Swift sources in Compile Sources (matches filesystem)
- ✅ Assets.xcassets + Localizable.xcstrings in Resources
- ✅ No duplicate file references
- 🔧 Fixed: Missing `/* Begin XCBuildConfiguration section */` header line
- 🔧 Fixed: Root group renamed from `Main` → `TropaymentMerchantProject`
- 🔧 Fixed: Products group given `name = Products`

### 2. Swift syntax
- ✅ Manual review of all 33 files — no obvious syntax errors
- ⚠️ Compiler parse **not run** (no Swift on Windows)

### 3. Imports / frameworks (iOS 16+)
- ✅ Foundation, SwiftUI, Combine, Security, LocalAuthentication only
- ✅ No third-party dependencies

### 4. SwiftUI iOS 16+ compatibility
- ✅ `NavigationStack` (iOS 16+)
- ✅ `.onChange(of:) { newValue in }` — iOS 14–16 form (not iOS 17 two-parameter)
- ✅ No `ContentUnavailableView`, `@Observable`, `#Preview` requires Xcode 15+ at compile time only
- ✅ `#Preview` macro — compile-time; deployment target iOS 16 is fine

### 5. Codable models
- ✅ `MerchantUser`, `LoginResponse`, `AuthModels` — aligned with Laravel JSON keys
- 🔧 Fixed: `MerchantUser` uses synthesized Codable (Encodable for Keychain snapshot)

### 6. async/await
- ✅ Used in APIClient, AuthService, AuthViewModel, AppSession

### 7. Actor isolation / MainActor
- ✅ `@MainActor` on APIClient, AuthService, AppSession, AuthViewModel
- ✅ KeychainManager intentionally nonisolated (Security APIs)

### 8. ObservableObject / StateObject / EnvironmentObject
- ✅ App: `@StateObject` session + authViewModel
- ✅ RootView: `@EnvironmentObject`
- ✅ LoginView: `@EnvironmentObject` authViewModel
- ✅ TwoFactorView: `@ObservedObject` (shared instance)

### 9. Navigation architecture
- ✅ Auth gate in RootView switch
- ✅ `NavigationStack` per tab + forgot-password sheet
- ✅ No NavigationView (deprecated pattern avoided)

### 10. Keychain
- ✅ Tokens in Keychain only
- 🔧 Fixed: Separate `session` vs `twoFactorPending` tokens + user snapshot
- ✅ `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`

### 11. LocalAuthentication
- ✅ BiometricManager foundation (not wired to UI yet — Phase 10)

### 12. APIClient request construction
- ✅ URLComponents + base URL `https://api.tropayment.com/api`
- 🔧 Fixed: `Content-Type` only when body present
- ✅ `Accept-Language` header

### 13. Bearer Sanctum token
- ✅ `Authorization: Bearer {token}`
- 🔧 Fixed: `readAuthToken()` — session preferred, pending for 2FA verify

### 14. HTTP status / error handling
- ✅ 401, 403, 422, 429, 503, 5xx mapped in `APIError`
- 🔧 Fixed: `requires_captcha` parsed from 422 responses

### 15. Authentication state transitions
- ✅ launching → unauthenticated | awaitingTwoFactor | authenticated

### 16. 401 session expiration
- ✅ NotificationCenter + AppSession.handleUnauthorized
- 🔧 Fixed: Don't clear session on 401 during login when no session token

### 17. 2FA flow
- ✅ Login → pending token → TwoFactorView → verify → full token
- 🔧 **Critical fix:** Bootstrap no longer calls `/v1/me` with pending token (2FA bypass)

### 18. Localization
- ✅ All UI keys defined in `Localizable.xcstrings`
- ⚠️ Many keys English-only; ar/zh/ko partial (subtitle, sign_in, etc.)
- ⚠️ Fallback to English at runtime — not a build blocker

### 19. Asset references
- ✅ `AppLogo` image in LoginView
- ✅ `AppIcon` 1024×1024 in asset catalog
- ✅ `AccentColor` defined
- ⚠️ Orphan `AppIcon.png` in appiconset (unused; harmless)

### 20. Bundle / app configuration
- ✅ `com.tropayment.merchant`
- ✅ Display name `tropayment Merchant`
- ✅ iOS 16.0 deployment target
- ✅ Finance category, Face ID usage string
- ⚠️ `DEVELOPMENT_TEAM = ""` — must set on Mac

### 21. iPhone / iPad
- ✅ `TARGETED_DEVICE_FAMILY = 1,2`
- ✅ Adaptive horizontal padding in LoginView
- ✅ TabView + NavigationStack (iPad acceptable for Phase 1)

### 22. Dark mode
- ✅ `TropaymentColors.background(for:)` / `surface(for:)` use colorScheme

### 23. RTL / Arabic
- ✅ Partial Arabic strings in catalog
- ⚠️ No explicit `layoutDirection` — SwiftUI auto-mirrors when device language is Arabic
- ⚠️ Full RTL QA requires simulator on Mac

### 24. iOS 17+ only APIs
- ✅ None identified in runtime code

### 25. Missing files referenced by Xcode
- ✅ None

### 26. Files on disk missing from target
- ✅ None (only `generate_xcode_project.py`, README, .gitignore excluded — intentional)

### 27. Duplicate symbols / source refs
- ✅ None in pbxproj

### 28. Hard-coded secrets
- ✅ None — only public API base URL

### 29. Sensitive logging
- ✅ Token/password never logged
- ✅ DEBUG logs: HTTP method + URL only (no Authorization header)

### 30. Fake financial data
- ✅ Placeholder screens only; no hard-coded balances/transactions

---

## Issues Found

| # | Severity | Issue |
|---|----------|-------|
| 1 | **Critical** | App relaunch during 2FA could skip verification via `/v1/me` with pending token |
| 2 | Medium | pbxproj missing XCBuildConfiguration section opener (corrupt object) |
| 3 | Medium | Duplicate `handleAPIError` / broken property order in AuthViewModel |
| 4 | Medium | 401 during login incorrectly triggered global logout |
| 5 | Low | `requires_captcha` from login 422 not parsed |
| 6 | Low | `Content-Type: application/json` sent on GET requests |
| 7 | Low | Root group named `Main` in Xcode navigator |
| 8 | Low | `globalError` from session never shown to user |
| 9 | Info | Turnstile captcha UI not implemented (notice only) |
| 10 | Info | Incomplete ar/zh/ko translations for many keys |
| 11 | Info | `DEVELOPMENT_TEAM` empty — required for device build |
| 12 | Info | No unit test target yet (Phase 13) |

---

## Issues Fixed (this pass)

1. **KeychainManager** — separate session / 2FA pending tokens + user JSON snapshot  
2. **AppSession.bootstrap** — restore 2FA screen instead of validating pending token via API  
3. **AuthService** — `savePendingTwoFactor`, token kinds  
4. **APIClient** — `readAuthToken()`, conditional Content-Type, Accept-Language restored  
5. **APIError** — `requiresCaptcha` on validation errors  
6. **AuthViewModel** — deduplicated, smarter 401 handling, captcha flag  
7. **MerchantUser** — synthesized Codable for encode/decode  
8. **RootView** — alert for `globalError`  
9. **project.pbxproj** — XCBuildConfiguration section + group naming  

---

## Remaining Issues (require macOS / Xcode)

1. **Actual compilation** — Swift type-checking, linking, asset compilation  
2. **Code signing** — set Development Team  
3. **Simulator/device testing** — login, 2FA, Keychain persistence, RTL  
4. **Turnstile captcha** — WebView/SDK when backend requires it  
5. **Complete localization** — ar, zh-Hans, ko for all keys  
6. **Biometric unlock** — wire BiometricManager (Phase 10)  
7. **App Store icon validation** — Xcode may warn about single-size AppIcon until full set added  

---

## Files Changed (verification fixes)

- `TropaymentMerchant/Core/Security/KeychainManager.swift`
- `TropaymentMerchant/Core/Session/AppSession.swift`
- `TropaymentMerchant/Core/Network/APIClient.swift`
- `TropaymentMerchant/Core/Network/APIError.swift`
- `TropaymentMerchant/Services/AuthService.swift`
- `TropaymentMerchant/Features/Auth/AuthViewModel.swift`
- `TropaymentMerchant/Models/User.swift`
- `TropaymentMerchant/App/RootView.swift`
- `TropaymentMerchant.xcodeproj/project.pbxproj`
- `STATIC_VERIFICATION.md` (this file)

---

## Ready for Real Xcode Build?

**Yes — with caveats.**

The project structure is consistent, static review passed, and a critical 2FA security gap was fixed. Open on a Mac, set the development team, and run:

```bash
xcodebuild -scheme TropaymentMerchant -destination 'platform=iOS Simulator,name=iPhone 16' build
```

**Do not treat as production-ready until that build succeeds and auth flows are tested on device/simulator.**

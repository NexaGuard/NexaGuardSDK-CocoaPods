# NexaGuard CMP iOS SDK (NexaGuardSDK)

***IAB‑TCF‑ and GPP‑compliant Consent Management Platform for native iOS & SwiftUI apps.***

Give your users a modern, custom‑branded consent dialogue in minutes – while staying 100 % in line with EU/UK GDPR, US State privacy laws and the IAB Transparency & Consent Framework v2.2.

---

## ✨ Key features

| ✓                                 | Capability                                                                                              |
| --------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **Drop‑in banner & second layer** | Ready‑made UI with light / dark adaptive themes and rounded‑corner layout.                              |
| **IAB TCF v2.2 & GPP**            | Full publisher CMP registration (CMP ID 471) – builds TC‑String in Core & Disclosed / Allowed segments. |
| **Offline‑first**                 | Ships a cached GVL snapshot and works without network once initialised.                                 |
| **Device‑storage disclosure**     | Vendor‑specific cookie/storage inventory dialog (Article 5 ePrivacy / §25 TTDSG).                       |
| **100 % Swift**                   | No Obj‑C runtime hacks, no trackers, no third‑party analytics.                                          |
| **Tiny footprint**                | \~180 KB zipped XCFramework, strings & images bundled via SPM resources.                                |

---

## 🔧 Requirements

- iOS **13.0** or later
- Xcode **15+**
- Swift **5.9** or newer

---

## 📦 Installation

### CocoaPods (recommended)

Add the pod to your *Podfile* and run `pod install`:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'NexaGuardSDK', '~> 1.0'
end
```

That’s it – the dynamic **NexaGuardSDK.xcframework** is pulled in automatically.

### Manual (XCFramework)

1. Clone / download this repository.
2. Run `./build_xcframework.sh` to generate *cmp/build/NexaGuardSDK.xcframework*.
3. Drag the XCFramework into Xcode **→ Frameworks, Libraries & Embedded Content** (set to *Embed & Sign*).

---

## 🚀 Quick start

```swift
import SwiftUI
import NexaGuardCMP   // re‑exported automatically by the framework

struct ContentView: View {
  @State private var cmpInitialised = false

  var body: some View {
    VStack(spacing: 24) {
      Text("Welcome to CMP Demo").font(.title)

      Button("Show CMP Banner") {
        NexaGuardCMP.shared.showBanner(force: true) // manual trigger
      }
    }
    .onAppear {
      guard !cmpInitialised else { return }
      NexaGuardCMP.shared.initialize(settingsId: "NXG‑Zmk9Zy0c1X") {
        print("✅ CMP core ready – TCString stored (if provided)")
      }
      cmpInitialised = true
    }
  }
}
```

> **Heads‑up for SwiftUI apps:**  The banner UI is built with UIKit, so the SDK needs the *top‑most* `UIViewController` to present from.  If you don’t already have such a helper, copy this tiny extension once in your project:
>
> ```swift
> import UIKit
> extension UIApplication {
>   func topViewController(base: UIViewController? = nil) -> UIViewController? {
>     let root = base ?? connectedScenes
>       .compactMap { ($0 as? UIWindowScene)?.keyWindow }
>       .first?.rootViewController
>     if let nav = root as? UINavigationController {
>       return topViewController(base: nav.visibleViewController)
>     }
>     if let tab = root as? UITabBarController,
>        let selected = tab.selectedViewController {
>       return topViewController(base: selected)
>     }
>     if let presented = root?.presentedViewController {
>       return topViewController(base: presented)
>     }
>     return root
>   }
> }
> ```

---

## 🛠 Advanced usage

| Helper                                                 | Purpose                                                                 |
| ------------------------------------------------------ | ----------------------------------------------------------------------- |
| `acceptAllSelections()`                                | Programmatically accept all purposes & vendors (second‑layer shortcut). |
| `rejectAllSelections()`                                | Programmatically decline all.                                           |
| `applyCustomSelections(purposes:[Int], vendors:[Int])` | Persist a custom selection set you captured in your own UI.             |
| `makeTCStringRejectAll()`                              | Generate a fully‑valid *Reject All* TCString without showing any UI.    |

The SDK persists consent in `UserDefaults` and exposes the raw TCString via `ConsentStorage.getTCString()`.

---

## 📄 Licence

The SDK is **commercial software** – see [`LICENSE`](LICENSE) for full terms. Usage requires an active NexaGuard CMP SaaS subscription.

---

## 🤝 Support & contact

- Email: [**ios@nexaguard.com**](mailto\:ios@nexaguard.com)
- Docs: [https://docs.nexaguard.com/ios](https://docs.nexaguard.com/ios)
- Dashboard: [https://dashboard.nexaguard.com](https://dashboard.nexaguard.com)

If you hit any issue, open a ticket in the NexaGuard dashboard or email us – we reply within one business day.

---

> Copyright © 2025 **NexaGuard Inc.**  All rights reserved.


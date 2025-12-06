# 🌊 PullMeDown

[![Pub Version](https://img.shields.io/pub/v/pull_me_down?color=blue)](https://pub.dev/packages/pull_me_down)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

A **Stunning**, **Fluid**, and **Professional** Pull-to-Refresh package for Flutter. 
Elevate your app's user experience with a **Liquid Elastic** animation that feels alive, minimal, and premium.

![PullMeDown Demo](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcDZmNXJ6b3J6b3J6b3J6b3J6b3J6b3J6b3J6b3J6b3J6b3J6/giphy.gif) 
*(Note: Replace with your own GIF/Screenshot)*

## ✨ Why PullMeDown?

- **🦄 Unique Aesthetic**: Stands out from the crowd with a premium elastic liquid feel (Pinterest/Twitter style curve).
- **🎨 Beautifully Customizable**: Adapts to your brand colors with a soft matte gradient finish.
- **🛠 Fully Controllable**: Customize the **liquid color**, **icon color**, and even the **loading widget** itself.
- **🤯 Haptic Feedback**: Integrates subtle vibrations for a satisfying tactile response.
- **🚀 Native Performance**: 60 FPS animations on both iOS and Android.
- **📱 Universal Physics**: Works seamlessly with `ClampingScrollPhysics` (Android) and `BouncingScrollPhysics` (iOS).

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  pull_me_down: ^0.0.1
```

## 🚀 Quick Usage

Simply wrap your list with `PullMeDown`.

```dart
import 'package:flutter/material.dart';
import 'package:pull_me_down/pull_me_down.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PullMeDown(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
        },
        refreshColor: Colors.teal, // Your brand color
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
        ),
      ),
    );
  }
}
```

## ⚙️ Advanced Customization

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `onRefresh` | `Future<void> Function()` | Required | The async refresh logic. |
| `refreshColor` | `Color` | `Theme.primaryColor` | The base color. We automatically generate a gradient for depth. |
| `refreshIconColor` | `Color?` | `Auto-Contrast` | Color of the spinner/arrow. If null, automatically picks Black/White based on contrast. |
| `loadingIndicator` | `Widget?` | `LiquidSpinner` | Provide your own custom widget (e.g. `CircularProgressIndicator`) to replace the default spinner. |
| `refreshTriggerPullDistance` | `double` | `100.0` | Pull distance required to trigger. |
| `refreshIndicatorExtent` | `double` | `80.0` | The resting height during refresh. |

### Example: Custom Loading Widget

```dart
PullMeDown(
  onRefresh: _refresh,
  loadingIndicator: CircularProgressIndicator(color: Colors.white), // Use your own!
  child: ListView(...),
)
```

## 💡 Pro Tips

**Handling Empty Lists**
If your list is empty, make sure the widget is still scrollable so the pull gesture works!

```dart
// Use this pattern for empty states
SingleChildScrollView(
  physics: AlwaysScrollableScrollPhysics(), // Critical!
  child: Container(
    height: MediaQuery.of(context).size.height,
    child: Center(child: Text("No items found")),
  ),
)
```

## 📄 License

MIT License. Open source and ready for your next big project.

---
Built with passion for Flutter 💙

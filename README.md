<div align="center">

# 🌊 PullMeDown

**The Ultimate Liquid Pull-to-Refresh Experience for Flutter**

[![Pub Version](https://img.shields.io/pub/v/pull_me_down?style=flat-square&color=blueviolet)](https://pub.dev/packages/pull_me_down)
[![Platform](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter&style=flat-square)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Stars](https://img.shields.io/github/stars/MurShidM01/pull_me_down?style=social)](https://github.com/MurShidM01/pull_me_down)

<br>

![PullMeDown Demo](https://raw.githubusercontent.com/MurShidM01/pull_me_down/main/screenshots/pull_me_down.gif)

<br>

**Minimalist. Fluid. Professional.**  
*Replace the boring standard loader with a stunning liquid elastic animation.*

</div>

---

## 📸 Visual Showcase

Experience the fluid animation in various themes.

| **Light Mode** | **Dark Mode** | **Custom Colors** |
|:---:|:---:|:---:|
| ![1](https://raw.githubusercontent.com/MurShidM01/pull_me_down/main/screenshots/Screenshot%20(01).png) | ![2](https://raw.githubusercontent.com/MurShidM01/pull_me_down/main/screenshots/Screenshot%20(02).png) | ![3](https://raw.githubusercontent.com/MurShidM01/pull_me_down/main/screenshots/Screenshot%20(03).png) |
| ![4](https://raw.githubusercontent.com/MurShidM01/pull_me_down/main/screenshots/Screenshot%20(04).png) | ![5](https://raw.githubusercontent.com/MurShidM01/pull_me_down/main/screenshots/Screenshot%20(05).png) | ![6](https://raw.githubusercontent.com/MurShidM01/pull_me_down/main/screenshots/Screenshot%20(06).png) |

---

## ✨ Key Features

- **🦄 Unique Aesthetic**  
  Stands out with a premium **Pinterest-style** elastic curve that feels organic and responsive.

- **🎨 Infinite Customization**  
  Full control over **Liquid Color**, **Icon Color**, and even user **Custom Widgets** (Lottie, Rive, etc.).

- **🤯 Haptic Feedback**  
  Built-in support for subtle **Haptic Vibrations** on refresh triggers for a tactile feel.

- **🚀 Native Performance**  
  Optimized for **60 FPS** on both Android (`ClampingScrollPhysics`) and iOS (`BouncingScrollPhysics`).

- **🌙 Dark Mode Ready**  
  Automatically adapts contrast and colors to look great in any theme.

---

## 📦 Installation

Run this command in your terminal:

```bash
flutter pub add pull_me_down
```

Or add it manually to `pubspec.yaml`:

```yaml
dependencies:
  pull_me_down: ^0.0.1
```

---

## 🚀 Usage

Wrap any scrollable widget (ListView, GridView, SingleChildScrollView) with `PullMeDown`.

```dart
import 'package:pull_me_down/pull_me_down.dart';

Scaffold(
  body: PullMeDown(
    onRefresh: () async {
      await Future.delayed(Duration(seconds: 2));
    },
    // Optional: Customize everything!
    refreshColor: Colors.teal,
    refreshIconColor: Colors.white,
    child: ListView.builder(
      itemCount: 20,
      itemBuilder: (ctx, i) => ListTile(title: Text("Item $i")),
    ),
  ),
)
```

### 🛠 Advanced Configuration

| Property | Type | Description |
|----------|------|-------------|
| `onRefresh` | `Future Function()` | **Required**. The async logic to run when refreshed. |
| `refreshColor` | `Color` | The main background color of the liquid shape. |
| `refreshIconColor` | `Color?` | Custom color for the spinner/arrow. Defaults to auto-contrast. |
| `loadingIndicator` | `Widget?` | Provide a custom widget (e.g. `CircularProgressIndicator`) to replace the default spinner. |
| `refreshTriggerPullDistance` | `double` | Distance to pull before refresh triggers (Default: `100.0`). |
| `refreshIndicatorExtent` | `double` | Height of the container while refreshing (Default: `80.0`). |

---

## 💡 Troubleshooting & Tips

### 🛑 List Not Scrolling?
If your list is empty, the `PullMeDown` gesture might not work because the Flutter `Scrollable` needs content to scroll. Fix it by ensuring your empty state is scrollable:

```dart
SingleChildScrollView(
  physics: AlwaysScrollableScrollPhysics(), // <--- IMPORTANT
  child: Container(
    height: MediaQuery.of(context).size.height,
    child: Text("Nothing to see here!"),
  ),
)
```

---

## 🤝 Contributing

Contributions are welcome! If you find a bug or want a feature, please [open an issue](https://github.com/MurShidM01/pull_me_down/issues).

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

<br>
<div align="center">
  <sub>Made with 💙 by <a href="https://github.com/MurShidM01">MurShidM01</a></sub>
</div>

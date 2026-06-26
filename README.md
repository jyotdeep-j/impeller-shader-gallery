# 🌈 Impeller Shader Gallery

> Real-time **GLSL fragment shaders** running on Flutter's **Impeller** rendering engine — no plugins, just `dart:ui`.

A tiny, dependency-free Flutter app that showcases one of the most exciting capabilities of modern Flutter: writing custom **fragment shaders** in GLSL and rendering them at 60/120fps via Impeller. Four animated shaders, one of them fully **interactive** (it follows your pointer / touch).

Built with **Flutter 3.38** & **Dart 3.10** (and yes — it uses the brand-new [dot-shorthand](https://dart.dev/language/dot-shorthands) syntax 👀).

<!-- Drop a recording here for the money shot:
<p align="center"><img src="docs/demo.gif" width="640" alt="Impeller Shader Gallery demo"/></p>
-->

---

## ✨ What's inside

| Shader | Technique |
| ------ | --------- |
| **Gradient Flow** | Fractal domain-repeat + Inigo Quilez cosine palette |
| **Plasma** | Classic summed-sine analog plasma field |
| **Tunnel** | Polar coordinates + `1/r` depth for an infinite tunnel |
| **Ripple** ⛯ | **Interactive** — concentric waves emanate from your pointer |

Every tile in the gallery is a **live, animated preview** — what you see scrolling is the shader actually running.

## 🧠 Why this is interesting

- **Impeller** is now Flutter's default renderer on iOS/Android. It precompiles shaders, so there's no runtime jank from shader compilation — perfect for effects like these.
- Fragment shaders run **on the GPU**, per-pixel, every frame. You get film-grade visual effects for effectively free on the CPU.
- **Zero dependencies.** This uses the native [`ui.FragmentProgram`](https://api.flutter.dev/flutter/dart-ui/FragmentProgram-class.html) API straight out of `dart:ui` — no `flutter_shaders`, no packages.

## 🏃 Run it

```bash
flutter pub get
flutter run            # mobile / desktop (Impeller)
# or try it in the browser:
flutter run -d chrome
```

> Requires Flutter ≥ 3.10 (tested on **Flutter 3.38.5 / Dart 3.10.4**).

## 🌐 Deploy to GitHub Pages

The project is web-enabled, so you can host the live demo for free:

```bash
flutter build web --base-href /<your-repo-name>/
# publish the build/web folder to the gh-pages branch
```

## 🔬 How it works

A shader is just a `.frag` file declaring its uniforms:

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2  uResolution;   // index 0,1
uniform float uTime;         // index 2
uniform vec2  uPointer;      // index 3,4  (interactive shaders only)

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    fragColor = vec4(uv, 0.5 + 0.5 * sin(uTime), 1.0);
}
```

Register it in `pubspec.yaml`:

```yaml
flutter:
  shaders:
    - shaders/ripple.frag
```

Then drive it from Dart. A `Ticker` advances `uTime` each frame and a
`CustomPainter` feeds the uniforms **in declaration order** before painting a
full-screen rect:

```dart
final program = await ui.FragmentProgram.fromAsset('shaders/ripple.frag');
final shader  = program.fragmentShader();

// in CustomPainter.paint(canvas, size):
shader.setFloat(0, size.width);   // uResolution.x
shader.setFloat(1, size.height);  // uResolution.y
shader.setFloat(2, time);         // uTime
shader.setFloat(3, pointer.dx);   // uPointer.x
shader.setFloat(4, pointer.dy);   // uPointer.y
canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
```

That's the whole trick. See [`lib/shader_canvas.dart`](lib/shader_canvas.dart).

## 📁 Project structure

```
shaders/                 # GLSL fragment shaders
  gradient_flow.frag
  plasma.frag
  tunnel.frag
  ripple.frag            # interactive (reads uPointer)
lib/
  main.dart              # app + scrollable live-preview gallery
  shaders_data.dart      # shader metadata
  shader_canvas.dart     # loads + animates a shader (the reusable core)
  shader_detail.dart     # fullscreen interactive view
test/
  widget_test.dart
```

## 🛠️ Make it yours

Add a shader in three steps:

1. Drop `shaders/my_shader.frag` in the `shaders/` folder.
2. Add it to the `shaders:` list in `pubspec.yaml`.
3. Append a `ShaderDef(...)` entry in [`lib/shaders_data.dart`](lib/shaders_data.dart).

It'll appear in the gallery automatically — animated preview and all.

---

<p align="center"><sub>Made with Flutter + Impeller. Shader math owes a debt to <a href="https://iquilezles.org/">Inigo Quilez</a> and the demoscene.</sub></p>

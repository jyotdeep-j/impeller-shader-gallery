import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Loads a fragment shader from the asset bundle and paints it every frame,
/// feeding it the standard `uResolution` / `uTime` uniforms (and an optional
/// `uPointer`).
///
/// Uniform indices are assigned in the order the uniforms are declared in the
/// `.frag` file:
///   0,1 -> uResolution (vec2)
///   2   -> uTime       (float)
///   3,4 -> uPointer    (vec2, only for pointer-aware shaders)
class ShaderCanvas extends StatefulWidget {
  const ShaderCanvas({
    super.key,
    required this.asset,
    this.usesPointer = false,
    this.pointer,
  });

  final String asset;
  final bool usesPointer;

  /// Pointer position in the widget's local coordinate space (logical pixels).
  final Offset? pointer;

  @override
  State<ShaderCanvas> createState() => _ShaderCanvasState();
}

class _ShaderCanvasState extends State<ShaderCanvas>
    with SingleTickerProviderStateMixin {
  ui.FragmentShader? _shader;
  late final Ticker _ticker;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _load();
    _ticker = createTicker((elapsed) {
      setState(() => _time = elapsed.inMicroseconds / Duration.microsecondsPerSecond);
    })..start();
  }

  Future<void> _load() async {
    final program = await ui.FragmentProgram.fromAsset(widget.asset);
    if (!mounted) return;
    setState(() => _shader = program.fragmentShader());
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (shader == null) {
      return const ColoredBox(color: Color(0xFF0B0B14));
    }
    return CustomPaint(
      size: Size.infinite,
      painter: _ShaderPainter(
        shader: shader,
        time: _time,
        usesPointer: widget.usesPointer,
        pointer: widget.pointer,
      ),
    );
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter({
    required this.shader,
    required this.time,
    required this.usesPointer,
    this.pointer,
  });

  final ui.FragmentShader shader;
  final double time;
  final bool usesPointer;
  final Offset? pointer;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);

    if (usesPointer) {
      final p = pointer ?? Offset(size.width / 2, size.height / 2);
      shader.setFloat(3, p.dx);
      shader.setFloat(4, p.dy);
    }

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant _ShaderPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';

import 'shader_canvas.dart';
import 'shaders_data.dart';

/// Fullscreen view of a single shader. Pointer-aware shaders track drag/hover.
class ShaderDetailScreen extends StatefulWidget {
  const ShaderDetailScreen({super.key, required this.def});

  final ShaderDef def;

  @override
  State<ShaderDetailScreen> createState() => _ShaderDetailScreenState();
}

class _ShaderDetailScreenState extends State<ShaderDetailScreen> {
  Offset? _pointer;

  @override
  Widget build(BuildContext context) {
    final def = widget.def;

    Widget canvas = ShaderCanvas(
      asset: def.asset,
      usesPointer: def.usesPointer,
      pointer: _pointer,
    );

    if (def.usesPointer) {
      canvas = MouseRegion(
        onHover: (e) => setState(() => _pointer = e.localPosition),
        child: GestureDetector(
          onPanUpdate: (e) => setState(() => _pointer = e.localPosition),
          onPanStart: (e) => setState(() => _pointer = e.localPosition),
          child: canvas,
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(def.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          canvas,
          // Caption pinned to the bottom with a readability scrim.
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    def.subtitle,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    def.usesPointer
                        ? 'Move your pointer or drag across the canvas.'
                        : 'GLSL fragment shader · running on Impeller.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

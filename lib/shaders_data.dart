import 'package:flutter/material.dart';

/// Metadata describing a single bundled fragment shader.
///
/// [asset] must match an entry under the `shaders:` section of `pubspec.yaml`.
/// [usesPointer] flags shaders that read the extra `uPointer` uniform so the
/// renderer knows it has to feed touch coordinates in.
class ShaderDef {
  const ShaderDef({
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.accent,
    this.usesPointer = false,
  });

  final String title;
  final String subtitle;
  final String asset;
  final Color accent;
  final bool usesPointer;
}

const shaders = <ShaderDef>[
  ShaderDef(
    title: 'Gradient Flow',
    subtitle: 'Fractal mesh-gradient · cosine palette',
    asset: 'shaders/gradient_flow.frag',
    accent: Color(0xFF7C4DFF),
  ),
  ShaderDef(
    title: 'Plasma',
    subtitle: 'Summed sine fields · analog vibes',
    asset: 'shaders/plasma.frag',
    accent: Color(0xFFFF6E40),
  ),
  ShaderDef(
    title: 'Tunnel',
    subtitle: 'Polar coordinates · infinite depth',
    asset: 'shaders/tunnel.frag',
    accent: Color(0xFF18FFFF),
  ),
  ShaderDef(
    title: 'Ripple',
    subtitle: 'Interactive · follows your touch',
    asset: 'shaders/ripple.frag',
    accent: Color(0xFF69F0AE),
    usesPointer: true,
  ),
];

import 'package:flutter/material.dart';

import 'shader_canvas.dart';
import 'shader_detail.dart';
import 'shaders_data.dart';

void main() {
  runApp(const ShaderGalleryApp());
}

class ShaderGalleryApp extends StatelessWidget {
  const ShaderGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impeller Shader Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Dart 3.10 dot-shorthands: `.dark` instead of `Brightness.dark`.
        brightness: .dark,
        colorScheme: .fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: .dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF06060C),
        useMaterial3: true,
      ),
      home: const GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            backgroundColor: Color(0xFF06060C),
            title: Text('Impeller Shader Gallery'),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Real-time GLSL fragment shaders rendered by Flutter\'s Impeller '
                'engine — no plugins, just dart:ui.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white60,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.82,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => ShaderTile(def: shaders[i]),
                childCount: shaders.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A live, animated preview tile that pushes the fullscreen view when tapped.
class ShaderTile extends StatelessWidget {
  const ShaderTile({super.key, required this.def});

  final ShaderDef def;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ShaderDetailScreen(def: def)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: def.asset,
              child: ShaderCanvas(asset: def.asset, usesPointer: def.usesPointer),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: def.accent,
                            shape: .circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            def.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: .w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (def.usesPointer)
                          const Icon(Icons.touch_app,
                              color: Colors.white70, size: 18),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      def.subtitle,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

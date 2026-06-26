// Smoke test for the Impeller Shader Gallery.

import 'package:flutter_test/flutter_test.dart';

import 'package:impeller_shader_gallery/main.dart';
import 'package:impeller_shader_gallery/shaders_data.dart';

void main() {
  testWidgets('Gallery renders a tile per shader', (WidgetTester tester) async {
    await tester.pumpWidget(const ShaderGalleryApp());
    await tester.pump();

    // The app title is shown in the large app bar.
    expect(find.text('Impeller Shader Gallery'), findsWidgets);

    // Each registered shader has a tappable tile.
    expect(find.byType(ShaderTile), findsNWidgets(shaders.length));

    // And each tile shows its title.
    for (final def in shaders) {
      expect(find.text(def.title), findsOneWidget);
    }
  });
}

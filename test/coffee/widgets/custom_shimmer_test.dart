import 'package:coffee_app/coffee/widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CustomShimmer', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        const CustomShimmer(
          child: SizedBox(
            width: 100,
            height: 100,
          ),
        ),
      );

      expect(find.byType(CustomShimmer), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('has correct gradient', (tester) async {
      await tester.pumpApp(
        const CustomShimmer(
          child: SizedBox(
            width: 100,
            height: 100,
          ),
        ),
      );

      final shaderMask = tester.widget<ShaderMask>(find.byType(ShaderMask));
      expect(shaderMask.blendMode, BlendMode.srcATop);
    });
  });
}

import 'package:coffee_app/coffee/widgets/coffee_image_placeholder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CoffeeImagePlaceholder', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpApp(
        const CoffeeImagePlaceholder(),
      );

      expect(find.byType(CoffeeImagePlaceholder), findsOneWidget);
    });
  });
}

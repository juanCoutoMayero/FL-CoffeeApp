import 'package:coffee_app/coffee/widgets/coffee_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CoffeeErrorView', () {
    testWidgets('renders default error message when message is null', (
      tester,
    ) async {
      await tester.pumpApp(
        const CoffeeErrorView(),
      );

      expect(find.text('Something went wrong!'), findsOneWidget);
    });

    testWidgets('renders custom error message when provided', (tester) async {
      const customMessage = 'Custom error message';

      await tester.pumpApp(
        const CoffeeErrorView(message: customMessage),
      );

      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('centers the error message', (tester) async {
      await tester.pumpApp(
        const CoffeeErrorView(),
      );

      expect(find.byType(Center), findsOneWidget);
    });
  });
}

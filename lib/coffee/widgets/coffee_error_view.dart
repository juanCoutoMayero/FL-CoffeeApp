import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// A widget that displays an error message for coffee-related failures.
///
/// This widget provides a consistent error display across the coffee feature,
/// showing a centered error message to the user.
class CoffeeErrorView extends StatelessWidget {
  /// Creates a [CoffeeErrorView].
  ///
  /// If [message] is not provided, a default error message will be displayed.
  const CoffeeErrorView({
    this.message,
    super.key,
  });

  /// The error message to display. If null, a default message is shown.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final errorMessage = message ?? context.l10n.somethingWentWrong;
    return Center(
      child: Text(errorMessage),
    );
  }
}

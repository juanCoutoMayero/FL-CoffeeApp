import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    CoffeeRepository? coffeeRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: coffeeRepository,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}

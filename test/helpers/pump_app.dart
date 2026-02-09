import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/app/cubit/theme_cubit.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    CoffeeRepository? coffeeRepository,
    ThemeCubit? themeCubit,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: coffeeRepository ?? MockCoffeeRepository(),
        child: BlocProvider.value(
          value: themeCubit ?? _buildMockThemeCubit(),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      ),
    );
  }
}

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

MockThemeCubit _buildMockThemeCubit() {
  final themeCubit = MockThemeCubit();
  when(() => themeCubit.state).thenReturn(ThemeMode.system);
  return themeCubit;
}

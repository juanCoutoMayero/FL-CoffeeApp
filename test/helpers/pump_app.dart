import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/app/cubit/theme_cubit.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monitoring_repository/monitoring_repository.dart';

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    CoffeeRepository? coffeeRepository,
    AnalyticsService? analyticsService,
    CrashlyticsService? crashlyticsService,
    ThemeCubit? themeCubit,
  }) {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: coffeeRepository ?? MockCoffeeRepository(),
          ),
          RepositoryProvider.value(
            value: analyticsService ?? _buildMockAnalyticsService(),
          ),
          RepositoryProvider.value(
            value: crashlyticsService ?? _buildMockCrashlyticsService(),
          ),
        ],
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

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockCrashlyticsService extends Mock implements CrashlyticsService {}

MockThemeCubit _buildMockThemeCubit() {
  final themeCubit = MockThemeCubit();
  when(() => themeCubit.state).thenReturn(ThemeMode.system);
  return themeCubit;
}

MockAnalyticsService _buildMockAnalyticsService() {
  final service = MockAnalyticsService();
  when(
    () => service.logEvent(name: any<String>(named: 'name')),
  ).thenAnswer((_) async {});
  return service;
}

MockCrashlyticsService _buildMockCrashlyticsService() {
  final service = MockCrashlyticsService();
  when(() => service.recordError(any(), any())).thenAnswer((_) async {});
  return service;
}

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/app/app.dart';
import 'package:coffee_app/app/cubit/theme_cubit.dart';
import 'package:coffee_app/coffee/view/coffee_page.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monitoring_repository/monitoring_repository.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockCrashlyticsService extends Mock implements CrashlyticsService {}

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  group('App', () {
    late CoffeeRepository coffeeRepository;
    late AnalyticsService analyticsService;
    late CrashlyticsService crashlyticsService;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      analyticsService = MockAnalyticsService();
      crashlyticsService = MockCrashlyticsService();

      when(() => coffeeRepository.getFavorites()).thenReturn([]);
      when(
        () => coffeeRepository.getFavoritesStream(),
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => coffeeRepository.getRandomCoffee(),
      ).thenAnswer((_) async => const Coffee(file: 'test'));
      when(() => coffeeRepository.isFavorite(any())).thenReturn(false);
      when(
        () => analyticsService.logEvent(name: any(named: 'name')),
      ).thenAnswer((_) async {});
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          coffeeRepository: coffeeRepository,
          analyticsService: analyticsService,
          crashlyticsService: crashlyticsService,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late CoffeeRepository coffeeRepository;
    late AnalyticsService analyticsService;
    late CrashlyticsService crashlyticsService;
    late ThemeCubit themeCubit;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      analyticsService = MockAnalyticsService();
      crashlyticsService = MockCrashlyticsService();
      themeCubit = MockThemeCubit();

      when(() => coffeeRepository.getFavorites()).thenReturn([]);
      when(
        () => coffeeRepository.getFavoritesStream(),
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => coffeeRepository.getRandomCoffee(),
      ).thenAnswer((_) async => const Coffee(file: 'test'));
      when(() => coffeeRepository.isFavorite(any())).thenReturn(false);
      when(
        () => analyticsService.logEvent(name: any(named: 'name')),
      ).thenAnswer((_) async {});
    });

    testWidgets('renders CoffeePage', (tester) async {
      when(() => themeCubit.state).thenReturn(ThemeMode.system);

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: coffeeRepository),
            RepositoryProvider.value(value: analyticsService),
            RepositoryProvider.value(value: crashlyticsService),
          ],
          child: BlocProvider.value(
            value: themeCubit,
            child: const AppView(),
          ),
        ),
      );

      expect(find.byType(CoffeePage), findsOneWidget);
    });

    testWidgets('renders MaterialApp with correct theme mode', (tester) async {
      when(() => themeCubit.state).thenReturn(ThemeMode.dark);

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: coffeeRepository),
            RepositoryProvider.value(value: analyticsService),
            RepositoryProvider.value(value: crashlyticsService),
          ],
          child: BlocProvider.value(
            value: themeCubit,
            child: const AppView(),
          ),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, equals(ThemeMode.dark));
    });
  });
}

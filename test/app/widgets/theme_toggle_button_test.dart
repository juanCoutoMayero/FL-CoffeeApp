import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/app/cubit/theme_cubit.dart';
import 'package:coffee_app/app/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  group('ThemeToggleButton', () {
    late ThemeCubit themeCubit;

    setUp(() {
      themeCubit = MockThemeCubit();
    });

    testWidgets('renders light mode icon when theme is dark', (tester) async {
      when(() => themeCubit.state).thenReturn(ThemeMode.dark);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ThemeCubit>.value(
            value: themeCubit,
            child: const Scaffold(
              body: ThemeToggleButton(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('renders dark mode icon when theme is light', (tester) async {
      when(() => themeCubit.state).thenReturn(ThemeMode.light);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ThemeCubit>.value(
            value: themeCubit,
            child: const Scaffold(
              body: ThemeToggleButton(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('calls toggleTheme when pressed', (tester) async {
      when(() => themeCubit.state).thenReturn(ThemeMode.light);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ThemeCubit>.value(
            value: themeCubit,
            child: const Scaffold(
              body: ThemeToggleButton(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      verify(() => themeCubit.toggleTheme()).called(1);
    });
  });
}

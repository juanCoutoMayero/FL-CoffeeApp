import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/app/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeCubit', () {
    test('initial state is ThemeMode.system', () {
      expect(ThemeCubit().state, equals(ThemeMode.system));
    });

    blocTest<ThemeCubit, ThemeMode>(
      'emits [ThemeMode.light] when toggleTheme is called and state is dark',
      build: () => ThemeCubit()..emit(ThemeMode.dark),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'emits [ThemeMode.dark] when toggleTheme is called and state is light',
      build: () => ThemeCubit()..emit(ThemeMode.light),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'emits [ThemeMode.dark] when toggleTheme is called and state is system',
      build: () => ThemeCubit(),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
    );
  });
}

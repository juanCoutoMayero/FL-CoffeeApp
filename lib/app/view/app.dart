import 'package:coffee_app/app/cubit/theme_cubit.dart';
import 'package:coffee_app/coffee/view/coffee_page.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    required this.coffeeRepository,
    super.key,
  });

  final CoffeeRepository coffeeRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: coffeeRepository,
      child: BlocProvider(
        create: (_) => ThemeCubit(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.brown,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.brown,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CoffeePage(),
        );
      },
    );
  }
}

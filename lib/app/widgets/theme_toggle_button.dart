import 'package:coffee_app/app/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A button widget that toggles between light and dark theme modes.
///
/// This widget displays an icon representing the opposite theme mode
/// (i.e., shows a sun icon in dark mode, moon icon in light mode) and
/// toggles the theme when pressed.
class ThemeToggleButton extends StatelessWidget {
  /// Creates a [ThemeToggleButton].
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return IconButton(
          icon: Icon(
            themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
        );
      },
    );
  }
}

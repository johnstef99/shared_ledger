import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const slPaddingHorizontal = 20.0;
const slPaddingVertical = 40.0;

const slEdgePadding = EdgeInsets.symmetric(
  horizontal: slPaddingHorizontal,
  vertical: slPaddingVertical,
);

final _elevatedBtnTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    fixedSize: const Size(double.infinity, 48),
    maximumSize: const Size(350, 48),
  ),
);

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: Colors.white,
  ),
  elevatedButtonTheme: _elevatedBtnTheme,
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Colors.white,
  ),
  elevatedButtonTheme: _elevatedBtnTheme,
);

class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier({required this.prefs}) : super(_getThemeMode(prefs));

  final SharedPreferences prefs;

  Future<void> update(ThemeMode Function(ThemeMode) update) async {
    value = update(value);
    await prefs.setString('themeMode', value.name);
  }

  static ThemeMode _getThemeMode(SharedPreferences prefs) {
    final themeMode = prefs.getString('themeMode');
    return switch (themeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}

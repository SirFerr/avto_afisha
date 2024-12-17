import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Состояния для управления темой
abstract class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}

class LightThemeState extends ThemeState {
  LightThemeState() : super(ThemeMode.light);
}

class DarkThemeState extends ThemeState {
  DarkThemeState() : super(ThemeMode.dark);
}

// Кубит для управления состоянием темы
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(LightThemeState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkTheme') ?? false;

    if (isDark) {
      emit(DarkThemeState());
    } else {
      emit(LightThemeState());
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDark);

    if (isDark) {
      emit(DarkThemeState());
    } else {
      emit(LightThemeState());
    }
  }
}

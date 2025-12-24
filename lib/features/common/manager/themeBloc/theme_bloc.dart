import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_event.dart';
import 'theme_state.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeLoaded>(_onThemeLoaded);
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeChanged>(_onThemeChanged);
  }

  Future<void> _onThemeLoaded(
      ThemeLoaded event,
      Emitter<ThemeState> emit,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    emit(state.copyWith(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    ));
  }

  Future<void> _onThemeToggled(
      ThemeToggled event,
      Emitter<ThemeState> emit,
      ) async {
    final newThemeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', newThemeMode == ThemeMode.dark);

    emit(state.copyWith(themeMode: newThemeMode));
  }

  Future<void> _onThemeChanged(
      ThemeChanged event,
      Emitter<ThemeState> emit,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', event.themeMode == ThemeMode.dark);

    emit(state.copyWith(themeMode: event.themeMode));
  }
}
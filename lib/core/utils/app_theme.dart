import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurantapp/core/utils/colors.dart';
class AppThemes {
  static ThemeData _baseTheme(
      ColorScheme colorScheme,
      Color scaffoldBg,
      Color bodyColor,
      Color displayColor,
      AppBarTheme appBarTheme,
      ) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: appBarTheme,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14),
      ).apply(
        bodyColor: bodyColor,
        displayColor: displayColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.backgroundLightColor,
        foregroundColor: bodyColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundLightColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
  static final lightTheme = _baseTheme(
    const ColorScheme.light(
      primary: AppColors.white,
      surface: AppColors.white,
      background: AppColors.white,
      onPrimary: AppColors.textColor,
      onSurface: AppColors.textColor,
      onBackground: AppColors.black,
    ),
    // AppColors.lightBackground, orqa fon uchun
    AppColors.lightDivider,
    AppColors.lightDivider,
    AppColors.black,
    const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  static final darkTheme = _baseTheme(
    const ColorScheme.dark(
      primary: AppColors.lightDivider,
      surface: AppColors.lightDivider,
      background: AppColors.lightDivider,
      onPrimary: AppColors.white,
      onSurface: AppColors.white,
      onBackground: AppColors.white,
    ),
    AppColors.lightText,
    AppColors.white,
    AppColors.white,
    const AppBarTheme(
      backgroundColor: AppColors.lightText,
      foregroundColor: AppColors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );
}

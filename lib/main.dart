import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/language.dart';
import 'package:restaurantapp/core/routing/router.dart';
import 'package:restaurantapp/features/common/manager/theme_bloc.dart';
import 'package:restaurantapp/features/common/manager/theme_state.dart';

import 'core/utils/app_theme.dart';
import 'features/common/manager/theme_event.dart';

late AppLocalization localization;
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  localization = AppLocalization('en');
  await localization.load();

  runApp(
    BlocProvider<ThemeBloc>(
      create: (_) => ThemeBloc()..add(ThemeLoaded()),
      child: const RestaurantApp(),
    ),
  );
}
class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430, 932),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: state.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}

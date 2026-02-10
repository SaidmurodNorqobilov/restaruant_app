import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:restaurantapp/core/routing/router.dart';
import 'package:restaurantapp/core/constants/app_theme.dart';
import 'package:restaurantapp/core/network/connection_service.dart';
import 'core/di/dependencies.dart';
import 'core/localization/langBloc/language_bloc.dart';
import 'core/localization/langBloc/language_state.dart';
import 'core/localization/themeBloc/theme_bloc.dart';
import 'core/localization/themeBloc/theme_state.dart';
import 'features/home/data/models/product_item_model.dart';
import 'features/onboarding/presentation/pages/no_internet_screen.dart';

void main() async {
  // await YandexMapkit.initialize(apiKey: 'YANDEX_API_KEY');
  WidgetsFlutterBinding.ensureInitialized();
  // await YandexMapkit.initialize(
  //   apiKey: 'd8509166-c9f8-4bd8-b2fc-d076071d93b3',
  // );
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await Hive.initFlutter();

  Hive.registerAdapter(
    ProductItemModelAdapter(),
  );
  Hive.registerAdapter(
    ProductModifierGroupModelAdapter(),
  );
  Hive.registerAdapter(
    ModifiersModelAdapter(),
  );

  await Hive.openBox<ProductItemModel>('cart_box');

  await Hive.openBox<ProductItemModel>('cart_box');
  runApp(
    MultiRepositoryProvider(
      providers: repositoryProviderMain,
      child: MultiBlocProvider(
        providers: blocProviderMain,
        child: const IzgaraApp(),
      ),
    ),
  );
}

class IzgaraApp extends StatelessWidget {
  const IzgaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, langState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: themeState.themeMode,
                home: StreamBuilder<List<ConnectivityResult>>(
                  stream: ConnectionService.connectionStream,
                  builder: (context, snapshot) {
                    final connectivity = snapshot.data;
                    if (connectivity != null &&
                        connectivity.contains(ConnectivityResult.none)) {
                      return const NoInternetScreen();
                    }
                    return MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      theme: AppThemes.lightTheme,
                      darkTheme: AppThemes.darkTheme,
                      themeMode: themeState.themeMode,
                      routerConfig: router,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
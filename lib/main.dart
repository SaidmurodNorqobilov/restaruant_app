import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/routing/router.dart';
import 'package:restaurantapp/core/utils/app_theme.dart';
import 'package:restaurantapp/features/accaunt/managers/user_profile_bloc.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_bloc.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_state.dart';
import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/data/repositories/auth_repository.dart';
import 'core/dependencies.dart';
import 'data/repositories/profile_repositroy.dart';
import 'data/repositories/user_profile_repository.dart';
import 'features/auth/managers/authCubit/auth_cubit.dart';
import 'features/auth/managers/profileCubit/profile_cubit.dart';
import 'features/common/manager/langBloc/language_bloc.dart';
import 'features/common/manager/langBloc/language_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final apiClient = ApiClient();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(client: apiClient),
        ),
        RepositoryProvider(
          create: (context) => ProfileRepository(client: apiClient),
        ),
        RepositoryProvider(
          create: (context) => UserProfileRepository(client: apiClient),)
      ],
      child: MultiBlocProvider(
        providers: [
          ...AppDependencies.providers,
          BlocProvider(
            create: (context) =>
                AuthCubit(
                  authRepository: context.read<AuthRepository>(),
                ),
          ),
          BlocProvider(
            create: (context) =>
                ProfileCubit(
                  profileRepository: context.read<ProfileRepository>(),
                ),
          ),
          BlocProvider<UserProfileBloc>(
            create: (context) =>
                UserProfileBloc(
                  repository: context.read<UserProfileRepository>(),
                ),
          ),
        ],
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
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: themeState.themeMode,
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }
}

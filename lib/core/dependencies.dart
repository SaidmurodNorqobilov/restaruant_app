import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_bloc.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_event.dart';
import '../features/common/manager/langBloc/language_bloc.dart';
import '../features/common/manager/langBloc/language_event.dart';

class AppDependencies {
  static List<BlocProvider> get providers => [
    BlocProvider<ThemeBloc>(
      create: (_) => ThemeBloc()..add(ThemeLoaded()),
    ),
    BlocProvider<LanguageBloc>(
      create: (_) => LanguageBloc()..add(LanguageLoaded()),
    ),
  ];
}
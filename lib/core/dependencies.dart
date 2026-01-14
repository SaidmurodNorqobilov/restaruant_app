import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_bloc.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_event.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/profile_repositroy.dart';
import '../data/repositories/user_profile_repository.dart';
import '../features/accaunt/managers/userBloc/user_profile_bloc.dart';
import '../features/auth/managers/authCubit/auth_cubit.dart';
import '../features/auth/managers/profileCubit/profile_cubit.dart';
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

final apiClient = ApiClient();

final repositoryProviderMain = <SingleChildWidget>[
  RepositoryProvider(
    create: (context) => AuthRepository(client: apiClient),
  ),
  RepositoryProvider(
    create: (context) => ProfileRepository(client: apiClient),
  ),
  RepositoryProvider(
    create: (context) => UserProfileRepository(client: apiClient),
  ),
];

final blocProviderMain = <SingleChildWidget>[
  ...AppDependencies.providers,
  BlocProvider(
    create: (context) => AuthCubit(
      authRepository: context.read<AuthRepository>(),
    ),
  ),
  BlocProvider(
    create: (context) => ProfileCubit(
      profileRepository: context.read<ProfileRepository>(),
    ),
  ),
  BlocProvider<UserProfileBloc>(
    create: (context) => UserProfileBloc(
      repository: context.read<UserProfileRepository>(),
    ),
  ),
];

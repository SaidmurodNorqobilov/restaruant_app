import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/features/cart/managers/cartBloc/cart_bloc.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_bloc.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_event.dart';
import 'package:restaurantapp/features/reservations/managers/reservation_bloc.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/cart_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/profile_repositroy.dart';
import '../data/repositories/reservations_repository.dart';
import '../data/repositories/user_profile_repository.dart';
import '../features/accaunt/managers/userBloc/user_profile_bloc.dart';
import '../features/auth/managers/authCubit/auth_cubit.dart';
import '../features/auth/managers/profileCubit/profile_cubit.dart';
import '../features/common/manager/langBloc/language_bloc.dart';
import '../features/common/manager/langBloc/language_event.dart';
import '../features/home/managers/productBloc/product_bloc.dart';

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
  RepositoryProvider(
    create: (context) => ReservationRepository(client: apiClient),
  ),
  RepositoryProvider(
    create: (context) => CartRepository(client: apiClient)..getCart(),
  ),
  RepositoryProvider(
    create: (context) => ProductRepository(client: apiClient),
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
  BlocProvider(
    create: (context) => ReservationBloc(
      repository: context.read<ReservationRepository>(),
    ),
  ),
  BlocProvider(
    create: (context) => CartBloc(
      repository: context.read<CartRepository>(),
    ),
  ),
  BlocProvider<ProductBloc>(
    create: (context) => ProductBloc(
      repository: context.read<ProductRepository>(),
    ),
  ),
];

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurantapp/core/network/client.dart';
import '../../features/accaunt/presentation/bloc/userBloc/user_profile_bloc.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/cart/data/repositories/cart_repository.dart';
import '../../features/home/data/repositories/product_repository.dart';
import '../../features/cart/data/repositories/profile_repositroy.dart';
import '../../features/accaunt/data/repositores/user_profile_repository.dart';
import '../../features/auth/presentation/bloc/authCubit/auth_cubit.dart';
import '../../features/auth/presentation/bloc/profileCubit/profile_cubit.dart';
import '../../features/cart/presentation/bloc/cartBloc/cart_bloc.dart';
import '../../features/home/presentation/bloc/productBloc/product_bloc.dart';
import '../../features/reservations/data/repositories/reservations_repository.dart';
import '../../features/reservations/presentation/bloc/reservation_bloc.dart';
import '../localization/langBloc/language_bloc.dart';
import '../localization/langBloc/language_event.dart';
import '../localization/themeBloc/theme_bloc.dart';
import '../localization/themeBloc/theme_event.dart';

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

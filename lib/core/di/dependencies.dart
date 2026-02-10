import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurantapp/core/network/client.dart';
import 'package:restaurantapp/features/cart/data/repositories/order_repository.dart';
import 'package:restaurantapp/features/cart/presentation/bloc/deliveryBloc/delivery_cubit.dart';
import 'package:restaurantapp/features/cart/presentation/bloc/orderBLoc/orders_bloc.dart';
import '../../features/account/data/repositores/location_repository.dart';
import '../../features/account/data/repositores/user_profile_repository.dart';
import '../../features/account/presentation/bloc/locationBloc/location_bloc.dart';
import '../../features/account/presentation/bloc/userBloc/user_profile_bloc.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/cart/data/repositories/cart_repository.dart';
import '../../features/cart/data/repositories/delivery_repository.dart';
import '../../features/home/data/repositories/product_repository.dart';
import '../../features/account/data/repositores/profile_repositroy.dart';
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
    create: (context) => CartRepository(client: apiClient),
  ),
  RepositoryProvider(
    create: (context) => ProductRepository(client: apiClient),
  ),
  RepositoryProvider(
    create: (context) => LocationRepository(client: apiClient),
  ),
  RepositoryProvider(
    create: (context) => OrderRepository(client: apiClient),
  ),
  RepositoryProvider(
    create: (context) => DeliveryRepository(apiClient: apiClient)..fetchDeliveries(),
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
  BlocProvider<MyLocationBloc>(
    create: (context) => MyLocationBloc(
      repository: context.read<LocationRepository>(),
    ),
  ),
  BlocProvider<OrdersBloc>(
    create: (context) => OrdersBloc(
      orderRepository: context.read<OrderRepository>(),
    ),
  ),
  BlocProvider<DeliveryCubit>(
    create: (context) => DeliveryCubit(
      deliveryRepository: context.read<DeliveryRepository>(),
    )..fetchDeliveries(),
  ),
];

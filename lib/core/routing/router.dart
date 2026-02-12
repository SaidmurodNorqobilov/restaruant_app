import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import '../../features/account/presentation/pages/about_page.dart';
import '../../features/account/presentation/pages/account_page.dart';
import '../../features/account/presentation/pages/edit_profile_page.dart';
import '../../features/account/presentation/pages/location_page.dart';
import '../../features/account/presentation/pages/my_locations_page.dart';
import '../../features/account/presentation/pages/refund_policy_page.dart';
import '../../features/cart/presentation/pages/address_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/cart/presentation/pages/checkout_page.dart';
import '../../features/cart/presentation/pages/order_detail_page.dart';
import '../../features/cart/presentation/pages/orders_page.dart';
import '../../features/cart/presentation/pages/payment_details_page.dart';
import '../../features/home/data/models/category_model.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_send_page.dart';
import '../../features/auth/presentation/pages/profile_sign_page.dart';
import '../../features/home/presentation/pages/categories_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/recipe_details_page.dart';
import '../../features/menu/presentation/pages/menu_page.dart';
import '../../features/onboarding/presentation/pages/Preferences_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/reservations/presentation/pages/my_reservation_page.dart';
import '../../features/reservations/presentation/pages/temporarily_reservation.dart';
import '../widgets/bottom_navigation_bar_app.dart';

final router = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.welcome,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: Routes.preferences,
      builder: (context, state) => const PreferencesPage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.otpSms,
      builder: (context, state) {
        return OtpSendPage(phone: state.extra as String? ?? '');
      },
    ),
    GoRoute(
      path: Routes.profileSign,
      builder: (context, state) => const ProfileSignPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBarApp(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.menu,
              builder: (context, state) => const MenuPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.reservations,
              builder: (context, state) => const TemporarilyReservation(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.cart,
              builder: (context, state) => const CartPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.account,
              builder: (context, state) => const AccountPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.categories,
      builder: (context, state) {
        final categoryId = state.extra as String? ?? "";
        return CategoriesPage(
          categoryId: categoryId,
        );
      },
    ),
    // GoRoute(
    //   path: Routes.promotions,
    //   builder: (context, state) {
    //     final id = state.extra as String? ?? "";
    //     return PromotionsPage(id: id);
    //   },
    // ),
    GoRoute(
      path: Routes.recipeDetails,
      builder: (context, state) {
        final product = state.extra as ProductModelItem;

        return RecipeDetailsPage(
          product: product,
        );
      },
    ),
    GoRoute(
      path: Routes.refund,
      builder: (context, state) => const RefundPolicyPage(),
    ),
    GoRoute(
      path: Routes.about,
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: Routes.checkout,
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: Routes.address,
      builder: (context, state) => const AddressPage(),
    ),
    GoRoute(
      path: Routes.payment,
      builder: (context, state) => const PaymentDetailsPage(),
    ),
    GoRoute(
      path: Routes.orders,
      builder: (context, state) => const OrdersPage(),
    ),
    GoRoute(
      path: Routes.orderDetail,
      builder: (context, state) => const OrderDetailPage(),
    ),
    GoRoute(
      path: Routes.editProfile,
      builder: (context, state) => EditProfilePage(),
    ),
    GoRoute(
      path: Routes.location,
      builder: (context, state) => const LocationPage(),
    ),
    GoRoute(
      path: Routes.myReservations,
      builder: (context, state) => const MyReservationsPage(),
    ),
    GoRoute(
      path: Routes.temporarilyReservation,
      builder: (context, state) => const TemporarilyReservation(),
    ),
    GoRoute(
      path: Routes.myLocations,
      builder: (context, state) => const MyLocationsPage(),
    ),
  ],
);

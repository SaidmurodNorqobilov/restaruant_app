import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/features/Reservations/pages/reservations_page.dart';
import 'package:restaurantapp/features/accaunt/pages/about_page.dart';
import 'package:restaurantapp/features/accaunt/pages/account_page.dart';
import 'package:restaurantapp/features/accaunt/pages/edit_profile_page.dart';
import 'package:restaurantapp/features/accaunt/pages/refund_policy_page.dart';
import 'package:restaurantapp/features/auth/pages/login_page.dart';
import 'package:restaurantapp/features/auth/pages/otp_send_page.dart';
import 'package:restaurantapp/features/auth/pages/profile_sign_page.dart';
import 'package:restaurantapp/features/cart/pages/address_page.dart';
import 'package:restaurantapp/features/cart/pages/cart_page.dart';
import 'package:restaurantapp/features/cart/pages/checkout_page.dart';
import 'package:restaurantapp/features/cart/pages/order_detail_page.dart';
import 'package:restaurantapp/features/cart/pages/order_page.dart';
import 'package:restaurantapp/features/cart/pages/payment_details_page.dart';
import 'package:restaurantapp/features/home/pages/categories_page.dart';
import 'package:restaurantapp/features/home/pages/promotions_page.dart';
import 'package:restaurantapp/features/home/pages/recipe_details_page.dart';
import 'package:restaurantapp/features/menu/pages/menu_page.dart';
import 'package:restaurantapp/features/onboarding/pages/Preferences_page.dart';
import 'package:restaurantapp/features/onboarding/pages/onboarding_page.dart';
import 'package:restaurantapp/features/onboarding/pages/splash_page.dart';
import 'package:restaurantapp/features/onboarding/pages/welcome_page.dart';
import 'package:restaurantapp/features/home/pages/home_page.dart';
import '../../data/models/category_model.dart';
import '../../features/accaunt/pages/location_page.dart';
import '../../features/common/widgets/bottom_navigation_bar_app.dart';

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
        final sessionId = state.extra as String? ?? '';
        return OtpSendPage(sessionId: sessionId);
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
              builder: (context, state) => const ReservationsPage(),
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
        final categoryId = state.extra as int? ?? 0;
        return CategoriesPage(
          categoryId: categoryId,
        );
      },
    ),
    GoRoute(
      path: Routes.promotions,
      builder: (context, state) {
        final id = state.extra as int? ?? 0;
        return PromotionsPage(id: id);
      },
    ),
    GoRoute(
      path: Routes.recipeDetails,
      builder: (context, state) {
        final product = state.extra as ProductModel;

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
      path: Routes.order,
      builder: (context, state) => const OrderPage(),
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
      builder: (context, state) => ReservationsPage(),
    ),
  ],
);

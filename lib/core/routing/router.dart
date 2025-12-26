import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/features/Reservations/pages/reservations_page.dart';
import 'package:restaurantapp/features/accaunt/pages/about_page.dart';
import 'package:restaurantapp/features/accaunt/pages/account_page.dart';
import 'package:restaurantapp/features/accaunt/pages/refund_policy_page.dart';
import 'package:restaurantapp/features/auth/pages/login_page.dart';
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
import '../../features/common/widgets/bottom_navigation_bar_app.dart';

final router = GoRouter(
  initialLocation: Routes.splash,
  routes: [
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
      path: Routes.onboarding,
      builder: (context, state) => OnboardingPage(),
    ),
    GoRoute(
      path: Routes.welcome,
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      path: Routes.preferences,
      builder: (context, state) => PreferencesPage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: Routes.categories,
      builder: (context, state) => CategoriesPage(),
    ),
    GoRoute(
      path: Routes.refund,
      builder: (context, state) => RefundPolicyPage(),
    ),
    GoRoute(
      path: Routes.about,
      builder: (context, state) => AboutPage(),
    ),
    GoRoute(
      path: Routes.recipeDetails,
      builder: (context, state) {
        final index = state.extra;
        return RecipeDetailsPage(productId: index as int);
      },
    ),
    GoRoute(
      path: Routes.promotions,
      builder: (context, state) {
        final index = state.extra;
        return PromotionsPage(id: index as int);
      },
    ),
    GoRoute(
      path: Routes.checkout,
      builder: (context, state) => CheckoutPage(),
    ),
    GoRoute(
      path: Routes.address,
      builder: (context, state) => AddressPage(),
    ),
    GoRoute(
      path: Routes.payment,
      builder: (context, state) => PaymentDetailsPage(),
    ),
    GoRoute(
      path: Routes.order,
      builder: (context, state) => OrderPage(),
    ),
    GoRoute(
      path: Routes.orderDetail,
      builder: (context, state) => OrderDetailPage(),
    ),
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => SplashPage(
      ),
    ),
  ],
);

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:restaurantapp/core/routing/routes.dart';
// import 'package:restaurantapp/features/reservations/pages/reservations_page.dart';
// import 'package:restaurantapp/features/accaunt/pages/about_page.dart';
// import 'package:restaurantapp/features/accaunt/pages/account_page.dart';
// import 'package:restaurantapp/features/accaunt/pages/refund_policy_page.dart';
// import 'package:restaurantapp/features/auth/pages/login_page.dart';
// import 'package:restaurantapp/features/cart/pages/address_page.dart';
// import 'package:restaurantapp/features/cart/pages/cart_page.dart';
// import 'package:restaurantapp/features/cart/pages/checkout_page.dart';
// import 'package:restaurantapp/features/cart/pages/order_detail_page.dart';
// import 'package:restaurantapp/features/cart/pages/order_page.dart';
// import 'package:restaurantapp/features/cart/pages/payment_details_page.dart';
// import 'package:restaurantapp/features/home/pages/categories_page.dart';
// import 'package:restaurantapp/features/home/pages/promotions_page.dart';
// import 'package:restaurantapp/features/home/pages/recipe_details_page.dart';
// import 'package:restaurantapp/features/menu/pages/menu_page.dart';
// import 'package:restaurantapp/features/onboarding/pages/Preferences_page.dart';
// import 'package:restaurantapp/features/onboarding/pages/onboarding_page.dart';
// import 'package:restaurantapp/features/onboarding/pages/welcome_page.dart';
// import 'package:restaurantapp/features/home/pages/home_page.dart';
//
// import '../../features/common/widgets/bottom_navigation_bar_app.dart';
//
// final router = GoRouter(
//   initialLocation: Routes.home,
//   routes: [
//     StatefulShellRoute.indexedStack(
//       builder: (context, state, navigationShell) {
//         return Scaffold(
//           body: navigationShell, // Bu tanlangan sahifani ko'rsatadi
//           bottomNavigationBar: BottomNavigationBarApp(navigationShell: navigationShell),
//         );
//       },
//       branches: [
//         StatefulShellBranch(routes: [GoRoute(path: Routes.home, builder: (context, state) => HomePage())]),
//         StatefulShellBranch(routes: [GoRoute(path: Routes.menu, builder: (context, state) => MenuPage())]),
//         StatefulShellBranch(routes: [GoRoute(path: Routes.reservations, builder: (context, state) => ReservationsPage())]),
//         StatefulShellBranch(routes: [GoRoute(path: Routes.cart, builder: (context, state) => CartPage())]),
//         StatefulShellBranch(routes: [GoRoute(path: Routes.account, builder: (context, state) => AccountPage())]),
//       ],
//     ),
//     GoRoute(
//       path: Routes.onboarding,
//       builder: (context, state) => OnboardingPage(),
//     ),
//     GoRoute(
//       path: Routes.welcome,
//       builder: (context, state) => WelcomePage(),
//     ),
//     GoRoute(
//       path: Routes.preferences,
//       builder: (context, state) => PreferencesPage(),
//     ),
//     GoRoute(
//       path: Routes.home,
//       builder: (context, state) => HomePage(),
//     ),
//     GoRoute(
//       path: Routes.login,
//       builder: (context, state) => LoginPage(),
//     ),
//     GoRoute(
//       path: Routes.cart,
//       builder: (context, state) => CartPage(),
//     ),
//     GoRoute(
//       path: Routes.menu,
//       builder: (context, state) => MenuPage(),
//     ),
//     GoRoute(
//       path: Routes.reservations,
//       builder: (context, state) => ReservationsPage(),
//     ),
//     GoRoute(
//       path: Routes.account,
//       builder: (context, state) => AccountPage(),
//     ),
//     GoRoute(
//       path: Routes.categories,
//       builder: (context, state) => CategoriesPage(),
//     ),
//     GoRoute(
//       path: Routes.refund,
//       builder: (context, state) => RefundPolicyPage(),
//     ),
//     GoRoute(
//       path: Routes.about,
//       builder: (context, state) => AboutPage(),
//     ),
//     GoRoute(
//       path: Routes.recipeDetails,
//       builder: (context, state) {
//         final index = state.extra;
//         return RecipeDetailsPage(
//           productId: index as int,
//         );
//       },
//     ),
//     GoRoute(
//       path: Routes.promotions,
//       builder: (context, state) {
//         final index = state.extra;
//         return PromotionsPage(id: index as int);
//       },
//     ),
//     GoRoute(
//       path: Routes.checkout,
//       builder: (context, state) => CheckoutPage(),
//     ),
//     GoRoute(
//       path: Routes.address,
//       builder: (context, state) => AddressPage(),
//     ),
//     GoRoute(
//       path: Routes.payment,
//       builder: (context, state) => PaymentDetailsPage(),
//     ),
//     GoRoute(
//       path: Routes.order,
//       builder: (context, state) => OrderPage(),
//     ),
//     GoRoute(
//       path: Routes.orderDetail,
//       builder: (context, state) => OrderDetailPage(
//       ),
//     ),
//   ],
// );
//
// //successni hali GoRoutega hali qo'shmadim

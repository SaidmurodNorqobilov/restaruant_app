import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_bloc.dart';
import 'package:restaurantapp/features/cart/managers/cartBloc/cart_bloc.dart';
import 'package:restaurantapp/features/cart/managers/cartBloc/cart_state.dart';
import 'package:restaurantapp/features/cart/widgets/cart_appbar_widget.dart';
import 'package:restaurantapp/features/cart/widgets/cart_item_widget.dart';
import 'package:restaurantapp/features/common/widgets/common_state_widgets.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/menu/pages/menu_page.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/icons.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../accaunt/managers/userBloc/user_profile_state.dart';
import '../../home/widgets/container_row.dart';
import '../widgets/auth_profile_empty_widget.dart';
import '../widgets/empty_cart_widgets.dart';
import '../widgets/placeholer_icon.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController tipController = TextEditingController();
  final TextEditingController controllerPromo = TextEditingController();
  final TextEditingController controllerSearch = TextEditingController();
  late AnimationController _animationController;

  final List<String> tableList = [
    'Table 1',
    'Table 2',
    'Table 3',
    'Table 4',
    'Table 5',
    'Table 6',
    'Table 7',
    'Table 8',
  ];

  String selectedTable = 'Table 1';
  bool isCouponApplied = false;
  bool _isSearching = false;
  List _filteredCartItems = [];

  @override
  void initState() {
    super.initState();
    setState(() {});
    context.read<CartBloc>().add(CartLoading());
    tipController.addListener(() {
      if (mounted) setState(() {});
    });
    controllerSearch.addListener(_filterCartItems);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    tipController.removeListener(() {});
    tipController.dispose();
    controllerSearch.removeListener(_filterCartItems);
    controllerSearch.dispose();
    _animationController.dispose();
    controllerPromo.dispose();
    super.dispose();
  }

  void _filterCartItems() {
    final cartState = context.read<CartBloc>().state;
    final allItems = cartState.cart ?? [];

    if (controllerSearch.text.isEmpty) {
      setState(() {
        _filteredCartItems = allItems;
      });
      return;
    }

    final searchQuery = controllerSearch.text.toLowerCase();
    setState(() {
      _filteredCartItems = allItems.where((item) {
        final productName = (item.product?.name ?? '').toLowerCase();
        return productName.contains(searchQuery);
      }).toList();
    });
  }

  double calculateSubtotal(List cartItems) {
    double total = 0;
    for (var item in cartItems) {
      total += (item.price ?? 0.0) * (item.quantity ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AnimatedSearchAppBar(
        isDark: isDark,
        title: context.translate('cart'),
        searchController: controllerSearch,
      ),
      drawer: const DrawerWidgets(),
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userState) {
          if (userState.status == Status.error || userState.user == null) {
            return const UnauthenticatedCartState();
          }
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState.status == Status.initial ||
                  cartState.status == Status.loading) {
                return LoadingState(
                  isDark: isDark,
                );
              }
              if (cartState.status == Status.error) {
                return ErrorState(
                  isDark: isDark,
                  onRetry: () {
                    context.read<CartBloc>().add(CartLoading());
                  },
                );
              }
              final allCartItems = cartState.cart ?? [];
              if (_filteredCartItems.isEmpty &&
                  allCartItems.isNotEmpty &&
                  controllerSearch.text.isEmpty) {
                _filteredCartItems = allCartItems;
              }
              final displayItems = controllerSearch.text.isEmpty
                  ? allCartItems
                  : _filteredCartItems;

              if (allCartItems.isEmpty) {
                return const EmptyCartState();
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  if (isLandscape || (isTablet && constraints.maxWidth > 700)) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: _buildCartList(
                            isTablet,
                            isDark,
                            true,
                            displayItems,
                            allCartItems,
                          ),
                        ),
                        VerticalDivider(
                          width: 1,
                          color: isDark ? Colors.white12 : Colors.grey[300],
                        ),
                        Expanded(
                          flex: 6,
                          child: _buildBottomSection(
                            isTablet,
                            isDark,
                            true,
                            allCartItems,
                          ),
                        ),
                      ],
                    );
                  }
                  return RefreshIndicator(
                    backgroundColor: isDark
                        ? AppColors.darkAppBar
                        : AppColors.primary,
                    color: AppColors.white,
                    onRefresh: () async {
                      context.read<CartBloc>().add(
                        CartLoading(),
                      );
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildCartList(
                            isTablet,
                            isDark,
                            false,
                            displayItems,
                            allCartItems,
                          ),
                        ),
                        _buildBottomSection(
                          isTablet,
                          isDark,
                          false,
                          allCartItems,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCartList(
    bool isTablet,
    bool isDark,
    bool isLandscape,
    List displayItems,
    List allCartItems,
  ) {
    if (displayItems.isEmpty && controllerSearch.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64.sp,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              context.translate('no_results_found'),
              style: TextStyle(
                fontSize: 16.sp,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      key: const PageStorageKey('cart_list'),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: displayItems.length + 1,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      separatorBuilder: (context, index) {
        if (index == 0) return const SizedBox.shrink();
        return SizedBox(height: 12.h);
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              controllerSearch.text.isEmpty
                  ? '${allCartItems.length} ${context.translate('itemsInCart')}'
                  : '${displayItems.length} Elementlar topildi',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
          );
        }

        final actualIndex = index - 1;
        if (actualIndex < 0 || actualIndex >= displayItems.length) {
          return const SizedBox.shrink();
        }

        final item = displayItems[actualIndex];
        if (item == null) {
          return const SizedBox.shrink();
        }

        return _buildCartItem(
          key: ValueKey('cart_item_${item.id ?? actualIndex}'),
          item: item,
          isLandscape: isLandscape,
          isDark: isDark,
          isTablet: isTablet,
        );
      },
    );
  }

  Widget _buildCartItem({
    Key? key,
    required dynamic item,
    required bool isLandscape,
    required bool isDark,
    required bool isTablet,
  }) {
    if (item == null) {
      return const SizedBox.shrink();
    }

    final product = item.product;
    final String? imageUrl = product?.image;
    final int itemQuantity = item.quantity ?? 1;
    final int itemId = item.id ?? 0;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return LoadingState(
            isDark: isDark,
          );
        }

        return CartItemWidget(
          item: item,
          product: product,
          itemQuantity: itemQuantity,
          itemId: itemId,
          isDark: isDark,
          isTablet: isTablet,
          isLandscape: isLandscape,
        );
      },
    );
  }

  Widget _buildBottomSection(
    bool isTablet,
    bool isDark,
    bool isLandscape,
    List cartItems,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: isLandscape
            ? double.infinity
            : MediaQuery.of(context).size.height * 0.6,
      ),
      padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
        borderRadius: isLandscape
            ? BorderRadius.horizontal(left: Radius.circular(24.r))
            : BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPricingSection(isDark, isTablet, isLandscape, cartItems),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: TextButtonApp(
                  onPressed: () {
                    context.push(Routes.checkout);
                  },
                  text: context.translate('checkout'),
                  buttonColor: AppColors.primary,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection(
    bool isDark,
    bool isTablet,
    bool isLandscape,
    List cartItems,
  ) {
    double subtotal = calculateSubtotal(cartItems);
    double vat = subtotal * 0.05;
    double tip = double.tryParse(tipController.text) ?? 0.0;
    double total = subtotal + vat + tip - (isCouponApplied ? 10.0 : 0.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _priceRow(
          context.translate('cartSubtotal'),
          'SO\'M ${subtotal.toStringAsFixed(2)}',
          isDark,
        ),
        Divider(
          color: AppColors.borderColor,
        ),
        _priceRow(
          "${context.translate('vat')} (5%)",
          'SO\'M ${vat.toStringAsFixed(2)}',
          isDark,
        ),
        if (tip > 0)
          _priceRow(
            context.translate('tip'),
            'SO\'M ${tip.toStringAsFixed(2)}',
            isDark,
          ),
        if (isCouponApplied)
          _priceRow(
            context.translate('discount'),
            '-SO\'M 10.00',
            isDark,
            color: Colors.green,
          ),
        Divider(
          color: AppColors.borderColor,
        ),
        _priceRow(
          context.translate('total'),
          'SO\'M ${total.toStringAsFixed(2)}',
          isDark,
          isBold: true,
        ),
      ],
    );
  }

  Widget _priceRow(
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? (isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

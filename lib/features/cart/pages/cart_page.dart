import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/Reservations/widgets/text_and_text_field.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_bloc.dart';
import 'package:restaurantapp/features/cart/managers/cartBloc/cart_bloc.dart';
import 'package:restaurantapp/features/cart/managers/cartBloc/cart_state.dart';
import 'package:restaurantapp/features/common/widgets/common_state_widgets.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

import '../../../core/utils/icons.dart';
import '../../accaunt/managers/userBloc/user_profile_state.dart';
import '../widgets/auth_profile_empty_widget.dart';
import '../widgets/empty_cart_widgets.dart';

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

  @override
  void initState() {
    super.initState();
    tipController.addListener(() {
      if (mounted) setState(() {});
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    context.read<CartBloc>().add(CartLoading());
  }

  @override
  void dispose() {
    tipController.removeListener(() {});
    tipController.dispose();
    _animationController.dispose();
    controllerPromo.dispose();
    controllerSearch.dispose();
    super.dispose();
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
        titleSpacing: 0,
        title: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AnimatedSlide(
              offset: _isSearching ? const Offset(-1.2, 0) : Offset.zero,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: _isSearching ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  context.translate("cart"),
                  key: const ValueKey('TitleText'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            AnimatedSlide(
              offset: _isSearching ? Offset.zero : const Offset(1.2, 0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: _isSearching ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  key: const ValueKey('SearchField'),
                  height: 40.h,
                  margin: EdgeInsets.only(right: 15.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blueGrey.shade700
                        : AppColors.orangeSearch,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controllerSearch,
                          autofocus: _isSearching,
                          style: const TextStyle(color: Colors.white),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: AppColors.white.withAlpha(179),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(100.r),
            onTap: () {
              if (mounted) {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    controllerSearch.clear();
                  }
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: SvgPicture.asset(
                  AppIcons.search,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                secondChild: const Icon(Icons.close, color: Colors.white),
                crossFadeState: _isSearching
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ),
          ),
        ],
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

              final cartItems = cartState.cart ?? [];

              if (cartItems.isEmpty) {
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
                            cartItems,
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
                            cartItems,
                          ),
                        ),
                      ],
                    );
                  }
                  return RefreshIndicator(
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
                            cartItems,
                          ),
                        ),
                        _buildBottomSection(isTablet, isDark, false, cartItems),
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
    List cartItems,
  ) {
    if (cartItems.isEmpty) {
      return const EmptyCartState();
    }

    return ListView.separated(
      key: const PageStorageKey('cart_list'),
      physics: const BouncingScrollPhysics(),
      itemCount: cartItems.length + 1,
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
              '${cartItems.length} ${context.translate('itemsInCart')}',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
          );
        }

        final actualIndex = index - 1;
        if (actualIndex < 0 || actualIndex >= cartItems.length) {
          return const SizedBox.shrink();
        }

        final item = cartItems[actualIndex];
        if (item == null) {
          return const SizedBox.shrink();
        }

        return _buildCartItem(
          key: ValueKey('cart_item_${item.id ?? actualIndex}'),
          index: actualIndex,
          isLandscape: isLandscape,
          isDark: isDark,
          isTablet: isTablet,
          cartItems: cartItems,
        );
      },
    );
  }

  Widget _buildCartItem({
    Key? key,
    required int index,
    required bool isLandscape,
    required bool isDark,
    required bool isTablet,
    required List cartItems,
  }) {
    if (index < 0 || index >= cartItems.length) {
      return const SizedBox.shrink();
    }

    final item = cartItems[index];
    if (item == null) {
      return const SizedBox.shrink();
    }

    final product = item.product;
    final String? imageUrl = product?.image;
    final int itemQuantity = item.quantity ?? 1;
    final int itemId = item.id ?? 0;

    return Container(
      key: key,
      height: isLandscape ? 72.h : 82.h,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(12.r),
            ),
            child: SizedBox(
              width: (isTablet ? 60.0 : 85.0).w,
              height: double.infinity,
              child: (imageUrl != null && imageUrl.isNotEmpty)
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderIcon(isDark),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                          ),
                        );
                      },
                    )
                  : _buildPlaceholderIcon(isDark),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product?.name ?? 'Unknown',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 12.sp : 14.sp,
                      color: isDark ? Colors.white : AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${(item.price ?? 0.0).toStringAsFixed(0)} SO'M",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8.w),
          //   child: CounterRow(
          //     count: itemQuantity,
          //     onIncrement: () {
          //       if (itemId > 0) {
          //         context.read<CartBloc>().add(
          //           CartUpdate(
          //             itemId: itemId,
          //             quantity: itemQuantity + 1,
          //           ),
          //         );
          //       }
          //     },
          //     onDecrement: () {
          //       if (itemQuantity > 1 && itemId > 0) {
          //         context.read<CartBloc>().add(
          //           CartUpdate(
          //             itemId: itemId,
          //             quantity: itemQuantity - 1,
          //           ),
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(bool isDark) {
    return Container(
      color: isDark ? Colors.white10 : Colors.grey[200],
      child: Icon(
        Icons.fastfood_rounded,
        color: isDark ? Colors.white30 : Colors.grey[400],
        size: 30.r,
      ),
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
              _buildCouponSection(isDark, isTablet),
              SizedBox(height: 12.h),
              _buildTipButton(isDark, isTablet),
              SizedBox(height: 12.h),
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
        const Divider(),
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

  Widget _buildCouponSection(bool isDark, bool isTablet) {
    if (isTablet) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controllerPromo,
            decoration: InputDecoration(
              hintText: context.translate('enterCouponCode'),
              filled: true,
              fillColor: isDark ? Colors.white10 : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: TextButtonApp(
              textColor: AppColors.white,
              onPressed: () {
                if (mounted) setState(() => isCouponApplied = true);
              },
              text: context.translate('applyCoupon'),
              buttonColor: AppColors.primary,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: controllerPromo,
              decoration: InputDecoration(
                hintText: context.translate('enterCouponCode'),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          TextButtonApp(
            textColor: AppColors.white,
            width: 100,
            onPressed: () {
              if (mounted) setState(() => isCouponApplied = true);
            },
            text: context.translate('applyCoupon'),
            buttonColor: AppColors.primary,
          ),
        ],
      );
    }
  }

  Widget _buildTipButton(bool isDark, bool isTablet) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          final color = Color.lerp(
            AppColors.primary,
            Colors.orange,
            _animationController.value,
          )!;
          return InkWell(
            onTap: () => _showTipBottomSheet(context, isTablet),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                border: Border.all(color: color.withOpacity(0.6), width: 1.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.volunteer_activism, color: color),
                  SizedBox(width: 10.w),
                  Text(
                    context.translate('tipWaiter'),
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTipBottomSheet(BuildContext context, bool isTablet) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkAppBar : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24.w,
          16.h,
          24.w,
          MediaQuery.of(context).viewInsets.bottom + 24.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 24.h),
            DropdownButtonFormField<String>(
              dropdownColor: isDark ? AppColors.darkAppBar : Colors.white,
              value: selectedTable,
              decoration: InputDecoration(
                labelText: context.translate('selectTable'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              items: tableList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (mounted && val != null) {
                  setState(() => selectedTable = val);
                }
              },
            ),
            SizedBox(height: 16.h),
            TextAndTextField(
              controller: tipController,
              text: context.translate('Pricing'),
              hintText: 'SO\'M 10.00',
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: TextButtonApp(
                onPressed: () {
                  if (mounted) setState(() {});
                  Navigator.pop(context);
                },
                text: context.translate('applyCoupon'),
                buttonColor: AppColors.primary,
                textColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

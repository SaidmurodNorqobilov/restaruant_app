import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/features/cart/presentation/bloc/deliveryBloc/delivery_cubit.dart';
import 'package:restaurantapp/features/cart/presentation/widgets/auth_required_dialog_widget.dart';
import 'package:restaurantapp/features/home/data/models/product_item_model.dart';
import '../../../../core/widgets/drawer_widgets.dart';
import '../../../account/presentation/bloc/userBloc/user_profile_bloc.dart';
import '../../../account/presentation/bloc/userBloc/user_profile_state.dart';
import '../../../onboarding/presentation/widgets/text_button_app.dart';
import '../../data/datasources/cart_service.dart';
import '../bloc/deliveryBloc/delivery_state.dart';
import '../widgets/cart_appbar_widget.dart';
import '../widgets/cart_item_widget.dart';
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
  final CartService cartService = CartService();

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
  List<ProductItemModel> _filteredCartItems = [];

  @override
  void initState() {
    super.initState();
    tipController.addListener(() {
      if (mounted) setState(() {});
    });
    controllerSearch.addListener(_filterCartItems);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    context.read<UserProfileBloc>().add(GetUserProfile());
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
    final allItems = cartService.getAllItems();

    if (controllerSearch.text.isEmpty) {
      setState(() {
        _filteredCartItems = allItems;
      });
      return;
    }

    final searchQuery = controllerSearch.text.toLowerCase();
    setState(() {
      _filteredCartItems = allItems.where((item) {
        final productName = item.name.toLowerCase();
        return productName.contains(searchQuery);
      }).toList();
    });
  }

  double calculateSubtotal(List<ProductItemModel> cartItems) {
    return cartService.getTotalPrice();
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
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ProductItemModel>('cart_box').listenable(),
        builder: (context, Box<ProductItemModel> box, _) {
          final allCartItems = box.values.toList();

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
                  setState(() {});
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
      ),
    );
  }

  Widget _buildCartList(
    bool isTablet,
    bool isDark,
    bool isLandscape,
    List<ProductItemModel> displayItems,
    List<ProductItemModel> allCartItems,
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

    return RefreshIndicator(
      backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
      color: AppColors.white,
      onRefresh: () async {
        setState(() {});
      },
      child: ListView.separated(
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
          return _buildCartItem(
            key: ValueKey('cart_item_${item.id}_$actualIndex'),
            item: item,
            isLandscape: isLandscape,
            isDark: isDark,
            isTablet: isTablet,
          );
        },
      ),
    );
  }

  Widget _buildCartItem({
    Key? key,
    required ProductItemModel item,
    required bool isLandscape,
    required bool isDark,
    required bool isTablet,
  }) {
    String? fullImageUrl;
    if (item.image.isNotEmpty) {
      fullImageUrl = item.image.startsWith('http')
          ? item.image
          : "http://45.138.158.158:3003${item.image}";
    }
    return CartItemWidget(
      item: item,
      product: item,
      imageUrl: fullImageUrl,
      itemQuantity: item.quantity,
      itemId: item.id,
      isDark: isDark,
      isTablet: isTablet,
      isLandscape: isLandscape,
    );
  }

  Widget _buildBottomSection(
    bool isTablet,
    bool isDark,
    bool isLandscape,
    List<ProductItemModel> cartItems,
  ) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) =>  Container(
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
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPricingSection(isDark, isTablet, isLandscape, cartItems),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButtonApp(
                    onPressed: () {
                      if (state.user == null) {
                        return AuthRequiredDialog.show(context, isDark);
                      }
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
      ),
    );
  }

  Widget _buildPricingSection(
    bool isDark,
    bool isTablet,
    bool isLandscape,
    List<ProductItemModel> cartItems,
  ) {
    double subtotal = calculateSubtotal(cartItems);
    double vat = subtotal * 0.00;
    double tip = double.tryParse(tipController.text) ?? 0.0;
    double total = subtotal + vat + tip - (isCouponApplied ? 10.0 : 0.0);
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      builder: (context, state) => Column(
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
      ),
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

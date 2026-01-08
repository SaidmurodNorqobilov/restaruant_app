import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/Reservations/widgets/text_and_text_field.dart';
import 'package:restaurantapp/features/home/widgets/container_row.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/icons.dart';

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

  final List<String> cartAddProducts = [
    'https://static.toiimg.com/photo/102941656.cms',
    'https://townsquare.media/site/385/files/2023/06/attachment-milkshake-.jpg?w=1200&q=75&format=natural',
    'https://townsquare.media/site/385/files/2023/06/attachment-milkshake-.jpg?w=1200&q=75&format=natural',
    'https://i.pinimg.com/originals/32/07/8e/32078e4d3c1e9edb4d76dba9a419f71f.jpg',
    'https://static.toiimg.com/photo/102941656.cms',
    'https://static.toiimg.com/photo/102941656.cms',
    'https://static.toiimg.com/photo/102941656.cms',
    'https://static.toiimg.com/photo/102941656.cms',
  ];

  final List<String> cartAddTitle = [
    'Provencal Breakf',
    '2 Provencal Breakf',
    '2 Provencal Breakf',
    '3 Provencal Breakf',
    '4 Provencal Breakf',
    '5 Provencal Breakf',
    '6 Provencal Breakf',
    '7 nimadirlar yana yana yana',
  ];

  final List<double> cartAddPrice = [
    20.0,
    70.0,
    50.0,
    23.0,
    45.0,
    30.0,
    40.0,
    50.0,
  ];
  List<int> quantities = [];
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
    quantities = List.generate(cartAddProducts.length, (index) => 1);
    tipController.addListener(() {
      if (mounted) setState(() {});
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
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

  double calculateSubtotal() {
    double total = 0;
    final length = cartAddPrice.length < quantities.length
        ? cartAddPrice.length
        : quantities.length;
    for (int i = 0; i < length; i++) {
      total += cartAddPrice[i] * quantities[i];
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
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: AppColors.white.withOpacity(0.7),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isLandscape || (isTablet && constraints.maxWidth > 700)) {
            return Row(
              children: [
                Expanded(
                  flex: 7,
                  child: _buildCartList(isTablet, isDark, true),
                ),
                VerticalDivider(
                  width: 1,
                  color: isDark ? Colors.white12 : Colors.grey[300],
                ),
                Expanded(
                  flex: 6,
                  child: _buildBottomSection(isTablet, isDark, true),
                ),
              ],
            );
          }
          return Column(
            children: [
              Expanded(child: _buildCartList(isTablet, isDark, false)),
              _buildBottomSection(isTablet, isDark, false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartList(bool isTablet, bool isDark, bool isLandscape) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: cartAddProducts.length + 1,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              '${cartAddProducts.length} ${context.translate('itemsInCart')}',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildCartItem(index - 1, isLandscape, isDark, isTablet),
        );
      },
    );
  }

  Widget _buildCartItem(
    int index,
    bool isLandscape,
    bool isDark,
    bool isTablet,
  ) {
    if (index < 0 || index >= cartAddProducts.length) {
      return const SizedBox.shrink();
    }

    return Container(
      height: isLandscape ? 72.h : 82.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
            child: Image.network(
              cartAddProducts[index],
              width: (isTablet ? 50.0 : 85.0).w,
              height: double.infinity,
              fit: BoxFit.cover,
              cacheWidth: 250,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: (isTablet ? 50.0 : 85.0).w,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                width: (isTablet ? 50.0 : 85.0).w,
                color: Colors.grey[200],
                child: const Icon(Icons.error_outline),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: isTablet ? 55.w : 150.w,
                    child: Text(
                      index < cartAddTitle.length ? cartAddTitle[index] : 'not found',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isTablet
                            ? FontWeight.w500
                            : FontWeight.w600,
                        fontSize: isTablet ? 7.sp : 14.sp,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    index < cartAddPrice.length
                        ? "AED ${cartAddPrice[index].toStringAsFixed(2)}"
                        : "AED 0.00",
                    style: const TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isTablet ? 8.w : 20.w, left: 18.w),
              child:
                  index <
                      quantities
                          .length
                  ? CounterRow(
                      count: quantities[index],
                      onIncrement: () {
                        if (mounted) {
                          setState(() => quantities[index]++);
                        }
                      },
                      onDecrement: () {
                        if (mounted) {
                          setState(() {
                            if (quantities[index] > 1) quantities[index]--;
                          });
                        }
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool isTablet, bool isDark, bool isLandscape) {
    return RepaintBoundary(
      child: Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: isLandscape || isTablet
                ? [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            _buildCouponSection(isDark, isTablet),
                            SizedBox(height: 12.h),
                            _buildTipButton(isDark, isTablet),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildPricingSection(isDark, isTablet, isLandscape),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButtonApp(
                        onPressed: () =>
                            _showAuthBottomSheet(context, isDark, isTablet),
                        text: context.translate('checkout'),
                        buttonColor: AppColors.primary,
                        textColor: Colors.white,
                      ),
                    ),
                  ]
                : [
                    _buildCouponSection(isDark, isTablet),
                    SizedBox(height: 12.h),
                    _buildTipButton(isDark, isTablet),
                    SizedBox(height: 12.h),
                    _buildPricingSection(isDark, isTablet, isLandscape),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButtonApp(
                        onPressed: () =>
                            _showAuthBottomSheet(context, isDark, isTablet),
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

  void _showAuthBottomSheet(BuildContext context, bool isDark, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 20.h,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 30.h),
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 50.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 30.h),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    context.translate('register'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.translate('auth_required_before_order'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.white.withOpacity(0.8)
                        : AppColors.black.withOpacity(0.7),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 45.h),
                Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.login);
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: AppColors.white,
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              context.translate('enter'),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          context.translate('cancel'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection(bool isDark, bool isTablet, bool isLandscape) {
    double subtotal = calculateSubtotal();
    double vat = subtotal * 0.05;
    double tip = double.tryParse(tipController.text) ?? 0.0;
    double total = subtotal + vat + tip - (isCouponApplied ? 10.0 : 0.0);

    return Column(
      children: [
        _priceRow(
          context.translate('cartSubtotal'),
          'AED ${subtotal.toStringAsFixed(2)}',
          isDark,
        ),
        _priceRow(
          "${context.translate('vat')} (5%)",
          'AED ${vat.toStringAsFixed(2)}',
          isDark,
        ),
        if (tip > 0)
          _priceRow(
            context.translate('tip'),
            'AED ${tip.toStringAsFixed(2)}',
            isDark,
          ),
        if (isCouponApplied)
          _priceRow(
            context.translate('discount'),
            '-AED 10.00',
            isDark,
            color: Colors.green,
          ),
        const Divider(),
        _priceRow(
          context.translate('total'),
          'AED ${total.toStringAsFixed(2)}',
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
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDark ? Colors.white70 : Colors.black87,
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
          SizedBox(
            width: 10.w,
          ),
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
                labelText: 'Select Table',
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
              hintText: 'AED 10.00',
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

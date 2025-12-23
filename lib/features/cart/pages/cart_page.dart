import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/Reservations/widgets/text_and_text_field.dart';
import 'package:restaurantapp/features/home/widgets/container_row.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/icons.dart';
import '../../../main.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin {
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
  ];
  final List<String> cartAddTitle = [
    'Provencal Breakf',
    '2 Provencal Breakf',
    '2 Provencal Breakf',
    '3 Provencal Breakf',
    '4 Provencal Breakf',
  ];
  final List<double> cartAddPrice = [20.0, 70.0, 50.0, 23.0, 45.0];

  int quantity = 1;
  final List<String> tableList = [
    'Table 1',
    'Table 2',
    'Table 3',
    'Table 4',
    'Table 5',
  ];
  String selectedTable = 'Table 1';
  bool isCouponApplied = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    controllerPromo.dispose();
    tipController.dispose();
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
        titleSpacing: 0,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearching
              ? Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              key: const ValueKey('SearchField'),
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: controllerSearch,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        controllerSearch.clear();
                      });
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          )
              : Text(
            localization.translate('cart'),
            key: const ValueKey('TitleText'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          if (!_isSearching)
            IconButton(
              onPressed: () => setState(() => _isSearching = true),
              icon: SvgPicture.asset(
                AppIcons.search,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
        ],
      ),
      drawer: const DrawerWidgets(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 40.w : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 10.h),
                      child: Text(
                        '${cartAddProducts.length} items in cart',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.textColor,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: cartAddProducts.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) => _buildCartItem(index),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 50.w : 16.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isCouponApplied) _buildCouponSection(),
                  SizedBox(height: 12.h),
                  _buildTipButton(context),
                  SizedBox(height: 12.h),
                  _buildPricingSection(),
                  SizedBox(height: 16.h),
                  TextButtonApp(
                    onPressed: () => context.push(Routes.checkout),
                    width: 403,
                    height: 50,
                    text: "Checkout",
                    textColor: AppColors.white,
                    buttonColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
            child: Image.network(
              cartAddProducts[index],
              width: 90.w,
              height: 85.h,
              fit: BoxFit.cover,
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
                    cartAddTitle[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: isDark ? AppColors.white : AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "AED ${cartAddPrice[index].toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CounterRow(
              count: quantity,
              onIncrement: () => setState(() => quantity < 99 ? quantity++ : null),
              onDecrement: () => setState(() => quantity > 1 ? quantity-- : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 42.h,
            child: TextField(
              controller: controllerPromo,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Promo code',
                filled: true,
                fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        TextButtonApp(
          width: 90,
          height: 42,
          onPressed: () {
            if (controllerPromo.text.isNotEmpty) setState(() => isCouponApplied = true);
          },
          text: 'Apply',
          textColor: AppColors.white,
          buttonColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildTipButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final color = Color.lerp(AppColors.primary, Colors.blueAccent, _animationController.value)!;
        return InkWell(
          onTap: () => _showTipBottomSheet(context),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 48.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              border: Border.all(width: 1.5, color: color.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volunteer_activism, size: 18.sp, color: color),
                SizedBox(width: 8.w),
                Text(
                  'Tip Waiter',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTipBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkAppBar : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              SizedBox(height: 20.h),
              Text('Support our staff', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.h),
              DropdownButtonFormField<String>(
                value: selectedTable,
                decoration: InputDecoration(
                  labelText: 'Select Table',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                items: tableList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setModalState(() => selectedTable = val!),
              ),
              SizedBox(height: 15.h),
              TextAndTextField(controller: tipController, text: 'Tip amount', hintText: 'AED 10.00'),
              SizedBox(height: 25.h),
              TextButtonApp(
                onPressed: () => Navigator.pop(context),
                text: "Confirm Tip",
                buttonColor: AppColors.primary,
                textColor: AppColors.white,
                width: 403,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _priceRow('Subtotal', 'AED 143.00', isDark),
        _priceRow('VAT (5%)', 'AED 7.15', isDark),
        if (isCouponApplied) _priceRow('Discount', '-AED 10.00', isDark, color: Colors.green),
        const Divider(height: 20),
        _priceRow('Total', 'AED 150.15', isDark, isBold: true),
      ],
    );
  }

  Widget _priceRow(String label, String value, bool isDark, {bool isBold = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.w400, color: isDark ? Colors.white70 : Colors.black87)),
          Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: isBold ? FontWeight.w900 : FontWeight.w600, color: color ?? (isDark ? Colors.white : Colors.black))),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:appbar_animated/appbar_animated.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/home/widgets/container_row.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/icons.dart';
import '../../../data/models/category_model.dart';

class RecipeDetailsPage extends StatefulWidget {
  final ProductModel product;

  const RecipeDetailsPage({super.key, required this.product});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  final String imageUrlBase = "https://atsrestaurant.pythonanywhere.com";
  int quantity = 1;

  double get totalPrice => widget.product.finalPrice * quantity;

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String fullImgUrl = widget.product.image.startsWith('http')
        ? widget.product.image
        : "$imageUrlBase${widget.product.image}";

    return Scaffold(
      body: ScaffoldLayoutBuilder(
        backgroundColorAppBar: ColorBuilder(
          Colors.transparent,
          isDark ? AppColors.darkAppBar : AppColors.primary,
        ),
        textColorAppBar: const ColorBuilder(Colors.white, Colors.white),
        appBarBuilder: (context, colorAnimated) {
          return AppBar(
            backgroundColor: colorAnimated.background,
            elevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset(
                AppIcons.backArrow,
                width: 38.w,
                height: 38.h,
                fit: BoxFit.scaleDown,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => context.pop(),
            ),
            title: AnimatedOpacity(
              opacity: colorAnimated.background == Colors.transparent
                  ? 0.0
                  : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.product.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    fullImgUrl, // Real rasm
                    width: double.infinity,
                    height: 363.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 363.h,
                      color: Colors.grey,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  bottom: MediaQuery.of(context).padding.bottom + 17.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 24.h),
                    Text(
                      widget.product.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        "AED ${totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    const Divider(),
                    SizedBox(height: 16.h),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.white.withOpacity(0.8)
                            : AppColors.textColor.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    const Divider(),
                    SizedBox(height: 24.h),
                    Center(
                      child: Column(
                        children: [
                          CounterRow(
                            count: quantity,
                            onIncrement: increment,
                            onDecrement: decrement,
                          ),
                          SizedBox(height: 24.h),
                          TextButtonApp(
                            onPressed: () {
                              _showSuccessBottomSheet(context, isDark);
                            },
                            text: 'Add to cart',
                            textColor: AppColors.white,
                            buttonColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    _buildNavigationButtons(isDark),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildNavigationButtons(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(30.r),
          onTap: () => context.pop(),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.borderColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.borderColor,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 8.w),
              const Text(
                'Previous',
                style: TextStyle(color: AppColors.borderColor),
              ),
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(30.r),
          onTap: () => context.go(Routes.cart),
          child: Row(
            children: [
              const Text(
                'Next meal',
                style: TextStyle(color: AppColors.primary),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 50.w,
                height: 50.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSuccessBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkAppBar : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Successfully added to cart',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.check_circle, color: AppColors.green, size: 48.w),
              ],
            ),
            SizedBox(height: 24.h),
            InkWell(
              onTap: () => context.go(Routes.cart),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'View Cart',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}

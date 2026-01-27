import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:appbar_animated/appbar_animated.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/data/repositories/product_repository.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_state.dart';
import 'package:restaurantapp/features/cart/pages/cart_page.dart';
import 'package:restaurantapp/features/home/managers/productBloc/product_bloc.dart';
import 'package:restaurantapp/features/home/managers/productBloc/product_state.dart';
import 'package:restaurantapp/features/home/widgets/container_row.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/client.dart';
import '../../../core/utils/icons.dart';
import '../../../data/models/category_model.dart';
import '../../accaunt/managers/userBloc/user_profile_bloc.dart';

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
  void initState() {
    context.read<UserProfileBloc>().add(GetUserProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isTablet = screenWidth >= 600;

    final String fullImgUrl = widget.product.image.startsWith('http')
        ? widget.product.image
        : "$imageUrlBase${widget.product.image}";

    return BlocProvider(
      create: (context) => ProductBloc(
        repository: ProductRepository(
          client: ApiClient(),
        ),
      ),
      child: Scaffold(
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
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state.status == Status.success) {
                _showSuccessBottomSheet(context, isDark);
              } else if (state.status == Status.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Xatolik yuz berdi"),
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      if (fullImgUrl.isEmpty)
                        Container(
                          height: 363.h,
                          color: Colors.grey,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                          ),
                        ),
                      if (fullImgUrl.isNotEmpty)
                        Image.network(
                          fullImgUrl,
                          width: double.infinity,
                          height: 363.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
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
                                Colors.black.withAlpha(179),
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
                            color: isDark
                                ? AppColors.white
                                : AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Center(
                          child: Text(
                            "${totalPrice.toStringAsFixed(2)} SO'M",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 22.h),
                        const Divider(),
                        SizedBox(height: 12.h),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.white
                                : AppColors.textColor,
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
                        BlocBuilder<UserProfileBloc, UserProfileState>(
                          builder: (context, userState) => Center(
                            child: Column(
                              children: [
                                CounterRow(
                                  count: quantity,
                                  onIncrement: increment,
                                  onDecrement: decrement,
                                ),
                                SizedBox(height: 24.h),
                                BlocConsumer<ProductBloc, ProductState>(
                                  listener: (context, state) {
                                    // if (state.status == Status.success) {
                                    //   // ScaffoldMessenger.of(
                                    //   //   context,
                                    //   // ).showSnackBar(
                                    //   //   const SnackBar(
                                    //   //     content: Text(
                                    //   //       "Savatga muvaffaqiyatli qo'shildi!",
                                    //   //     ),
                                    //   //     backgroundColor: Colors.green,
                                    //   //   ),
                                    //   // );
                                    // } else if (state.status == Status.error) {
                                    //   ScaffoldMessenger.of(
                                    //     context,
                                    //   ).showSnackBar(
                                    //     SnackBar(
                                    //       content: Text("Xatolik yuz berdi"),
                                    //       backgroundColor: Colors.red,
                                    //     ),
                                    //   );
                                    // }
                                  },
                                  builder: (context, state) {
                                    return TextButtonApp(
                                      onPressed: () {
                                        if (userState.status !=
                                                Status.success ||
                                            userState.user == null) {
                                          return _showLoginDialog(
                                            context,
                                            isDark,
                                            isTablet,
                                          );
                                        }

                                        context.read<ProductBloc>().add(
                                          AddOrderItemEvent(
                                            productId: widget.product.id,
                                            quantity: quantity,
                                          ),
                                        );
                                      },
                                      text: state.status == Status.loading
                                          ? 'Adding...'
                                          : 'Add to cart',
                                      textColor: AppColors.white,
                                      buttonColor: AppColors.primary,
                                    );
                                  },
                                ),
                              ],
                            ),
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
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context, bool isDark, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: isTablet
              ? MediaQuery.of(context).size.height * 0.65
              : MediaQuery.of(context).size.height * 0.55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.black.withAlpha(230),
                      AppColors.black.withOpacity(0.8),
                    ]
                  : [
                      AppColors.white.withAlpha(230),
                      AppColors.white.withOpacity(0.8),
                    ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 34.h),
            child: Column(
              children: [
                Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(128),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 35.h),
                Icon(
                  Icons.person_outline_rounded,
                  size: 80.sp,
                  color: AppColors.primary,
                ),
                SizedBox(height: 37.h),
                Text(
                  'Ro\'yxatdan o\'ting',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 26.h),
                Text(
                  'Savatga qo\'shishdan oldin tizimga kirishingiz kerak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButtonApp(
                  text: 'Kirish',
                  onPressed: () => Navigator.pop(modalContext),
                  width: 272,
                  height: 50,
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () => Navigator.pop(modalContext),
                  child: Text(
                    'Bekor qilish',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
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
                  color: AppColors.borderColor.withAlpha(77),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.borderColor,
                  size: 20.w,
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
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20.w,
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.green,
                size: 48.sp,
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              "Vanilla shake",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Successfully added to cart",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.green,
              ),
            ),
            SizedBox(height: 24.h),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'View Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Continue Shopping',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showRecipeDetailBottomSheet(
    BuildContext context,
    ProductModel product,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrlBase = "https://atsrestaurant.pythonanywhere.com";
    int quantity = 1;

    String fullImgUrl = product.image.startsWith('http')
        ? product.image
        : "$imageUrlBase${product.image}";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkAppBar : Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28.r),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(
                      fullImgUrl,
                      width: double.infinity,
                      height: 220.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            product.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "${(product.finalPrice * quantity).toStringAsFixed(2)} SO'M",
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 18.h),
                          Divider(),
                          SizedBox(height: 12.h),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Text(
                                product.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  height: 1.6,
                                  color: isDark
                                      ? AppColors.white.withOpacity(0.8)
                                      : AppColors.textColor.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() => quantity--);
                                  }
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  size: 28.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              IconButton(
                                onPressed: () {
                                  setState(() => quantity++);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: 28.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Add to cart",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

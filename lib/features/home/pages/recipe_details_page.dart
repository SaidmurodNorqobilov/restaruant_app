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
import 'package:restaurantapp/features/home/managers/productBloc/product_bloc.dart';
import 'package:restaurantapp/features/home/managers/productBloc/product_state.dart';
import 'package:restaurantapp/features/home/widgets/container_row.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/client.dart';
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
                opacity: colorAnimated.background == Colors.transparent ? 0.0 : 1.0,
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
                  SnackBar(content: Text(state.errorMessage ?? "Xatolik yuz berdi")),
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
                          child: const Icon(Icons.broken_image, color: Colors.white),
                        ),
                      if (fullImgUrl.isNotEmpty)
                        Image.network(
                          fullImgUrl,
                          width: double.infinity,
                          height: 363.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 363.h,
                            color: Colors.grey,
                            child: const Icon(Icons.broken_image, color: Colors.white),
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
                                Colors.black.withAlpha(179)
,
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
                              BlocBuilder<ProductBloc, ProductState>(
                                builder: (context, state) {
                                  return TextButtonApp(
                                    onPressed:
                                        () {
                                      // AddOrderItemEventni chaqiramiz
                                      context.read<ProductBloc>().add(
                                        AddOrderItemEvent(
                                          orderId: 0,
                                          productId: widget.product.id,
                                          quantity: quantity,
                                          // orderId: widget.product.,
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
                  color: AppColors.borderColor.withAlpha(77)
,
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
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20.h),
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16.h),
            Text(
              "Savatga qo'shildi!",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.black : Colors.black,
              ),
            ),
            SizedBox(height: 24.h),
            TextButtonApp(
              textColor: AppColors.primary,
              onPressed: () {
                Navigator.pop(context);
                context.go(Routes.cart);
              },
              text: "Savatga o'tish",
              buttonColor: AppColors.primary,
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Davom etish"),
            ),
          ],
        ),
      ),
    );
  }
}
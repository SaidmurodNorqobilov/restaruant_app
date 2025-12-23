import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:appbar_animated/appbar_animated.dart'; // Import qiling
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/home/widgets/container_row.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/icons.dart';

class RecipeDetailsPage extends StatefulWidget {
  final int productId;

  const RecipeDetailsPage({super.key, required this.productId});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  // ScrollController qo'shish kerak
  final ScrollController _scrollController = ScrollController();

  List breakfastList = [
    'https://i.pinimg.com/736x/2d/64/85/2d6485a63c2af38bee13e5ca13bf42b6.jpg',
    'https://i.pinimg.com/736x/29/cc/61/29cc6154b06aaf45a1276cf460b714a7.jpg',
    'https://www.foodandwine.com/thmb/eN9iNzrq2SrcDOnkR5CJm2dr2A4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/full-english-breakfast-FT-Recipe0225-0bab8edfd24a44b087a3548254dbb409.jpeg',
    'https://i.pinimg.com/736x/56/4a/1d/564a1d27337ce2fff4b15ee2098eceaa.jpg',
    'https://i.pinimg.com/736x/22/4f/f1/224ff168322e1f318852ed49b0937d14.jpg',
  ];

  List breakfastTitle = ['ovqat', 'ovqat1', 'ovqat2', 'ovqa3', 'ovqat4'];
  List breakfastText = [
    'wegfaergraeg',
    'erg er aergg',
    'oerg ergrgea2',
    'ov reaqaer gerga',
    'oregaerg vqat4',
  ];

  List<double> breakfastPrice = [32.00, 23.00, 23.00, 76.00, 100.00];

  List breakfastReview = [
    """Viennoiseries, assorted breadbasket served with jam and butter, and eggs your way. Choice of freshly squeezed juice or hot beverage.
(D, G, N)""",
    """ 2 222 adbasdib vdsdv sivbsdipvb aspivbpsduivb sd va sdvv sdvi adsivh sdiv as v sv""",
    """ 3333  ads33ds fsd fsdaf ds fds fafd fsadf dsfsdfsd""",
    """ 44 444sdafsdfsdfsdfsdf""",
    """ 555555dsfasdfa sdf j j jjdsfdsfadsf""",
  ];

  int quantity = 1;
  double get totalPrice => breakfastPrice[widget.productId] * quantity;

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

    return Scaffold(
      body: ScaffoldLayoutBuilder(
        backgroundColorAppBar: ColorBuilder(
          Colors.transparent, // Scroll qilmagan payt
          isDark ? AppColors.darkAppBar : AppColors.primary, // Scroll qilganda
        ),
        textColorAppBar: ColorBuilder(
          Colors.white, // Har doim oq
          Colors.white,
        ),
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
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => context.pop(),
            ),
            title: AnimatedOpacity(
              opacity: colorAnimated == Colors.transparent ? 0.0 : 1.0,
              duration: Duration(milliseconds: 200),
              child: Text(
                breakfastTitle[widget.productId],
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
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Hero Image
              Stack(
                children: [
                  Image.network(
                    breakfastList[widget.productId],
                    width: double.infinity,
                    height: 363.h,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
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

              // Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Title & Price
                    Text(
                      breakfastText[widget.productId],
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
                    Divider(),
                    SizedBox(height: 16.h),

                    // Description
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
                      breakfastReview[widget.productId],
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
                    Divider(),
                    SizedBox(height: 24.h),

                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
        // Previous Button
        InkWell(
          borderRadius: BorderRadius.circular(30.r),
          onTap: () {
            // Previous logic
          },
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
              Text(
                'Previous',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColors.borderColor,
                ),
              ),
            ],
          ),
        ),

        // Next Button
        InkWell(
          borderRadius: BorderRadius.circular(30.r),
          onTap: () {
            context.go(Routes.cart);
          },
          child: Row(
            children: [
              Text(
                'Next meal',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 24.w,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        breakfastTitle[widget.productId],
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Successfully added to cart',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 48.w,
                ),
              ],
            ),
            SizedBox(height: 24.h),
            InkWell(
              onTap: () {
                context.pop();
                context.push(Routes.cart);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                    SizedBox(width: 12.w),
                    Text(
                      'View Cart',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
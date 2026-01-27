import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/icons.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

class EmptyCartState extends StatefulWidget {
  const EmptyCartState({super.key});

  @override
  State<EmptyCartState> createState() => _EmptyCartStateState();
}

class _EmptyCartStateState extends State<EmptyCartState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height:
              MediaQuery.of(context).size.height -
              (Scaffold.of(context).hasAppBar ? kToolbarHeight : 0) -
              MediaQuery.of(context).padding.top,
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 120.w : 40.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: isTablet ? 180.w : 140.w,
                        height: isTablet ? 180.h : 140.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    AppColors.primary.withOpacity(0.2),
                                    AppColors.primary.withOpacity(0.05),
                                  ]
                                : [
                                    AppColors.primary.withOpacity(0.15),
                                    AppColors.primary.withOpacity(0.05),
                                  ],
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppIcons.cart,
                            width: isTablet ? 90.w : 70.w,
                            height: isTablet ? 90.h : 70.h,
                            colorFilter: ColorFilter.mode(
                              AppColors.primary.withOpacity(0.6),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 40.h : 32.h),
                    Text(
                      'Savatchada mahsulotlar topilmadi!' ??
                          'Your Cart Is Empty!',
                      style: TextStyle(
                        fontSize: isTablet ? 28.sp : 24.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Text(
                    //   'emptyCartDescription' ??
                    //       'When you add products, they\'ll appear here. Start exploring our delicious menu!',
                    //   style: TextStyle(
                    //     fontSize: isTablet ? 18.sp : 16.sp,
                    //     fontWeight: FontWeight.w400,
                    //     color: isDark
                    //         ? AppColors.white.withOpacity(0.7)
                    //         : AppColors.textColor.withOpacity(0.7),
                    //     height: 1.5,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    SizedBox(height: isTablet ? 48.h : 40.h),

                    Column(
                      children: [
                        SizedBox(
                          width: isTablet ? 350.w : double.infinity,
                          height: isTablet ? 56.h : 50.h,
                          child: TextButtonApp(
                            onPressed: () {
                              context.go(Routes.home);
                            },
                            text: "Ko'rib chiqish" ?? 'Browse Menu',
                            buttonColor: AppColors.primary,
                            textColor: Colors.white,
                          ),
                        ),

                        // SizedBox(
                        //   width: isTablet ? 350.w : double.infinity,
                        //   height: isTablet ? 56.h : 50.h,
                        //   child: OutlinedButton(
                        //     onPressed: () {
                        //       context.go(Routes.home);
                        //     },
                        //     style: OutlinedButton.styleFrom(
                        //       side: BorderSide(
                        //         color: AppColors.primary,
                        //         width: 2,
                        //       ),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12.r),
                        //       ),
                        //     ),
                        //     child: Text(
                        //       '' ?? 'Go to Home',
                        //       style: TextStyle(
                        //         color: AppColors.primary,
                        //         fontSize: isTablet ? 16.sp : 14.sp,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    // SizedBox(height: isTablet ? 60.h : 40.h),
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: isTablet ? 32.w : 24.w,
                    //     vertical: isTablet ? 24.h : 20.h,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: isDark
                    //         ? AppColors.darkAppBar.withOpacity(0.5)
                    //         : AppColors.primary.withOpacity(0.05),
                    //     borderRadius: BorderRadius.circular(16.r),
                    //     border: Border.all(
                    //       color: AppColors.primary.withOpacity(0.2),
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.lightbulb_outline,
                    //         color: AppColors.primary,
                    //         size: isTablet ? 32.r : 28.r,
                    //       ),
                    //       SizedBox(width: 16.w),
                    //       Expanded(
                    //         child: Text(
                    //           context.translate('emptyCartTip') ??
                    //               'Tip: Add items to your cart and enjoy special offers!',
                    //           style: TextStyle(
                    //             fontSize: isTablet ? 15.sp : 13.sp,
                    //             color: isDark
                    //                 ? AppColors.white.withOpacity(0.8)
                    //                 : AppColors.textColor.withOpacity(0.8),
                    //             height: 1.4,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

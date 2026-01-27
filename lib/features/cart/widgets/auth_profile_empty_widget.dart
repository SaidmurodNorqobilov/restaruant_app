import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/icons.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

/// Autentifikatsiya talab qilinadigan holat uchun UI komponenti
/// Foydalanuvchi tizimga kirmagan bo'lsa ko'rsatiladi
class UnauthenticatedCartState extends StatefulWidget {
  const UnauthenticatedCartState({super.key});

  @override
  State<UnauthenticatedCartState> createState() =>
      _UnauthenticatedCartStateState();
}

class _UnauthenticatedCartStateState extends State<UnauthenticatedCartState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
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

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 80.w : 24.w,
            vertical: 20.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isTablet ? 200.w : 160.w,
                height: isTablet ? 200.h : 160.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      AppColors.primary.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: isTablet ? 140.w : 110.w,
                      height: isTablet ? 140.h : 110.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                    SvgPicture.asset(
                      AppIcons.cart,
                      width: isTablet ? 80.w : 65.w,
                      height: isTablet ? 80.h : 65.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    Positioned(
                      bottom: isTablet ? 20.h : 15.h,
                      right: isTablet ? 20.w : 15.w,
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 10.r : 8.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: isTablet ? 24.r : 20.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 48.h : 40.h),
              Text(
                "Ro'yxatdan o'tish kerak",
                style: TextStyle(
                  fontSize: isTablet ? 32.sp : 26.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.white : AppColors.textColor,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: isTablet ? 20.h : 16.h),

              // Text(
              //   context.translate('loginDescription') ??
              //       'Please sign in to view your cart and place orders. Join us to enjoy our delicious menu!',
              //   style: TextStyle(
              //     fontSize: isTablet ? 18.sp : 16.sp,
              //     fontWeight: FontWeight.w400,
              //     color: isDark
              //         ? AppColors.white.withOpacity(0.75)
              //         : AppColors.textColor.withOpacity(0.7),
              //     height: 1.6,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              SizedBox(height: isTablet ? 56.h : 48.h),
              _buildFeatureList(isDark, isTablet),
              SizedBox(height: isTablet ? 56.h : 48.h),
              Column(
                children: [
                  SizedBox(
                    width: isTablet ? 400.w : double.infinity,
                    height: isTablet ? 60.h : 54.h,
                    child: TextButtonApp(
                      onPressed: () {
                        context.push(Routes.login);
                      },
                      text: context.translate('Kirish') ?? 'Sign In',
                      buttonColor: AppColors.primary,
                      textColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // SizedBox(
                  //   width: isTablet ? 400.w : double.infinity,
                  //   height: isTablet ? 60.h : 54.h,
                  //   child: OutlinedButton(
                  //     onPressed: () {
                  //       context.push(Routes.login);
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
                  //       context.translate('createAccount') ?? 'Create Account',
                  //       style: TextStyle(
                  //         color: AppColors.primary,
                  //         fontSize: isTablet ? 17.sp : 15.sp,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 20.h),
                  TextButton.icon(
                    onPressed: () {
                      context.go(Routes.home);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark
                          ? AppColors.white.withOpacity(0.7)
                          : AppColors.textColor.withOpacity(0.7),
                      size: isTablet ? 22.r : 20.r,
                    ),
                    label: Text(
                      context.translate('continueAsGuest') ??
                          'Continue as Guest',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.white.withOpacity(0.7)
                            : AppColors.textColor.withOpacity(0.7),
                        fontSize: isTablet ? 16.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList(bool isDark, bool isTablet) {
    final features = [
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'Oson buyurtma berish',
        'description': 'Buyurtma berish oson',
      },
      {
        'icon': Icons.history,
        'title': 'Buyurtma tarixi',
        'description': 'Barcha oldingi buyurtmalaringizni kuzatib boring',
      },
      {
        'icon': Icons.local_offer_outlined,
        'title': 'Eksklyuziv takliflar',
        'description': "Maxsus chegirmalar va chegirmalarga ega bo'ling",
      },
    ];

    return Container(
      padding: EdgeInsets.all(isTablet ? 28.w : 20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar.withOpacity(0.6) : Colors.grey[50],
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: features.asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;
          return Column(
            children: [
              _buildFeatureItem(
                icon: feature['icon'] as IconData,
                title: feature['title'] as String,
                description: feature['description'] as String,
                isDark: isDark,
                isTablet: isTablet,
              ),
              if (index < features.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 20.h : 16.h,
                  ),
                  child: Divider(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey[300],
                    height: 1,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
    required bool isTablet,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 14.r : 12.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: isTablet ? 28.r : 24.r,
          ),
        ),
        SizedBox(width: isTablet ? 18.w : 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 18.sp : 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: isTablet ? 15.sp : 13.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.white.withOpacity(0.65)
                      : AppColors.textColor.withOpacity(0.65),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

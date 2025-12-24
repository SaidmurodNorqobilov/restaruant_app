import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/icons.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    // Background animation
    _backgroundController.forward();

    // Logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Text animation
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Navigate to home after 3 seconds total
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      context.go(Routes.home);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary.withOpacity(0.6),
                ],
                stops: [
                  0.0,
                  _backgroundAnimation.value * 0.5,
                  _backgroundAnimation.value,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated circles background
                _buildAnimatedCircles(),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo animation
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Opacity(
                              opacity: _logoOpacityAnimation.value,
                              child: Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(30.w),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 2,
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.2),
                                            Colors.white.withOpacity(0.05),
                                          ],
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        AppIcons.menu,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.white,
                                          BlendMode.srcIn,
                                        ),
                                        width: 100.w,
                                        height: 100.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 40.h),

                      // Text animation
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _textSlideAnimation,
                            child: FadeTransition(
                              opacity: _textOpacityAnimation,
                              child: Column(
                                children: [
                                  Text(
                                    'ATS',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 8,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'MENU',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 48.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 4,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  // Loading indicator
                                  SizedBox(
                                    width: 40.w,
                                    height: 40.h,
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedCircles() {
    return Stack(
      children: [
        // Circle 1
        Positioned(
          top: -100.h,
          right: -100.w,
          child: AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Transform.scale(
                scale: _backgroundAnimation.value,
                child: Container(
                  width: 300.w,
                  height: 300.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              );
            },
          ),
        ),

        // Circle 2
        Positioned(
          bottom: -150.h,
          left: -150.w,
          child: AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Transform.scale(
                scale: _backgroundAnimation.value,
                child: Container(
                  width: 400.w,
                  height: 400.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.03),
                  ),
                ),
              );
            },
          ),
        ),

        // Circle 3
        Positioned(
          top: 200.h,
          left: -50.w,
          child: AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Transform.scale(
                scale: _backgroundAnimation.value * 0.8,
                child: Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
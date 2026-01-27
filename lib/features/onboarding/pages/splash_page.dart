import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/icons.dart';
import 'package:restaurantapp/core/network/auth_storage.dart';
import '../../../core/utils/onboarding_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
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

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _textOpacityAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _textController,
            curve: Curves.easeIn,
          ),
        );
    _textSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _textController,
            curve: Curves.easeOutCubic,
          ),
        );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    try {
      _backgroundController.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      _logoController.forward();
      await Future.delayed(const Duration(milliseconds: 600));
      _textController.forward();

      await Future.delayed(const Duration(milliseconds: 2500));

      if (!mounted) return;
      final String? token = await AuthStorage.getToken().timeout(
        const Duration(seconds: 2),
        onTimeout: () => null,
      );

      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        context.go(Routes.home);
        return;
      }
      final bool hasSeenOnboarding = await OnboardingService.hasSeenOnboarding();

      if (!hasSeenOnboarding) {
        context.go(Routes.onboarding);
      } else {
        context.go(Routes.welcome);
      }
    } catch (e) {
      if (mounted) context.go(Routes.welcome);
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
      backgroundColor: AppColors.primary,
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
                _buildAnimatedCircles(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(),
                      SizedBox(height: 40.h),
                      _buildText(),
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

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white10,
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
                        color: Colors.white24,
                        width: 2,
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
    );
  }

  Widget _buildText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textOpacityAnimation,
            child: Column(
              children: [
                Text(
                  'IZGARA',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 8,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'CAFE',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: 20.h),
                const CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCircles() {
    return Stack(
      children: [
        _circle(top: -100.h, right: -100.w, size: 300.w, opacity: 0.05),
        _circle(bottom: -150.h, left: -150.w, size: 400.w, opacity: 0.03),
        _circle(
          top: 200.h,
          left: -50.w,
          size: 200.w,
          opacity: 0.04,
          scale: 0.8,
        ),
      ],
    );
  }

  Widget _circle({
    double? top,
    double? right,
    double? bottom,
    double? left,
    required double size,
    required double opacity,
    double scale = 1.0,
  }) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) => Transform.scale(
          scale: _backgroundAnimation.value * scale,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity),
            ),
          ),
        ),
      ),
    );
  }
}

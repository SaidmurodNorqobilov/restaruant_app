import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/icons.dart';

class BottomNavigationBarApp extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigationBarApp({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = navigationShell.currentIndex;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.r),
        topRight: Radius.circular(25.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkAppBar.withOpacity(0.8)
                : AppColors.lightDivider.withOpacity(0.8),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: SnakeNavigationBar.color(
            backgroundColor: Colors.transparent,
            behaviour: SnakeBarBehaviour.pinned,
            snakeShape: SnakeShape.circle,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 40.w : 5.w,
              vertical: 8.h,
            ),
            elevation: 0,
            snakeViewColor: AppColors.primary,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.primary,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            currentIndex: currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
            selectedLabelStyle: TextStyle(
              fontSize: isTablet ? 8.sp : 10.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: isTablet ? 8.sp : 10.sp,
              fontWeight: FontWeight.w400,
            ),
            items: [
              _buildNavItem(
                AppIcons.home,
                context.translate('home'),
                0,
                currentIndex,
              ),
              _buildNavItem(
                AppIcons.forkSpoon,
                context.translate('menuBottom'),
                1,
                currentIndex,
              ),
              _buildNavItem(
                AppIcons.tableBar,
                context.translate('reservation'),
                2,
                currentIndex,
              ),
              _buildNavItem(
                AppIcons.shoppingCart,
                context.translate('cart'),
                3,
                currentIndex,
              ),
              _buildNavItem(
                AppIcons.profile,
                context.translate('profile'),
                4,
                currentIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
  BottomNavigationBarItem _buildNavItem(
    String icon,
    String label,
    int index,
    int currentIndex,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        width: 22.w,
        height: 22.h,
        colorFilter: ColorFilter.mode(
          currentIndex == index ? AppColors.white : AppColors.primary,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}

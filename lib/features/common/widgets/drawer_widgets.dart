import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/icons.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_bloc.dart';
import 'package:restaurantapp/features/common/manager/themeBloc/theme_event.dart';
import '../manager/langBloc/language_bloc.dart';
import '../manager/langBloc/language_event.dart';
import '../manager/langBloc/language_state.dart';

class DrawerWidgets extends StatelessWidget {
  const DrawerWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {
        return Drawer(
          surfaceTintColor: AppColors.white,
          shadowColor: AppColors.white,
          backgroundColor: isDark
              ? AppColors.lightText
              : AppColors.lightDivider,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 290.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/appLogo/divider.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        context.translate('language'),
                        style: TextStyle(
                          fontSize: isTablet ? 10.sp : 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.white : AppColors.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          dropdownColor: isDark
                              ? AppColors.darkAppBar
                              : AppColors.white,
                          value: langState.languageCode,
                          underline: const SizedBox(),
                          onChanged: (value) {
                            if (value != null) {
                              context.read<LanguageBloc>().add(
                                LanguageChanged(value),
                              );
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: 'ru',
                              child: Text('Русский'),
                            ),
                            DropdownMenuItem(
                              value: 'uz',
                              child: Text("O'zbek"),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.language,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _drawerItem(
                context,
                icon: Icons.home,
                text: context.translate('home'),
                onPressed: () => context.go(Routes.home),
                isDark: isDark,
              ),
              _drawerItem(
                context,
                icon: Icons.restaurant_menu,
                text: context.translate('menu'),
                onPressed: () => context.go(Routes.menu),
                isDark: isDark,
              ),
              _drawerItem(
                context,
                icon: Icons.local_offer,
                text: context.translate('promotions'),
                onPressed: () => context.push(Routes.promotions, extra: 1),
                isDark: isDark,
              ),
              _drawerItem(
                context,
                icon: FontAwesomeIcons.receipt,
                text: context.translate('orders'),
                onPressed: () => context.push(Routes.order),
                isDark: isDark,
              ),
              const Divider(),
              _drawerItem(
                context,
                icon: FontAwesomeIcons.circleInfo,
                text: context.translate('about'),
                onPressed: () => context.push(Routes.about),
                isDark: isDark,
              ),
              _drawerItem(
                context,
                icon: Icons.currency_exchange,
                text: context.translate('refund'),
                onPressed: () => context.push(Routes.refund),
                isDark: isDark,
              ),
              _drawerItem(
                context,
                icon: FontAwesomeIcons.fileContract,
                text: context.translate('terms'),
                onPressed: () {},
                isDark: isDark,
              ),
              const Divider(),
              _drawerItem(
                context,
                icon: FontAwesomeIcons.calendarCheck,
                text: context.translate('reservation'),
                onPressed: () => context.go(Routes.reservations),
                isDark: isDark,
              ),
              _drawerItem(
                context,
                icon: FontAwesomeIcons.commentDots,
                text: context.translate('feedback'),
                onPressed: () {},
                isDark: isDark,
              ),
              _buildAnimatedThemeToggle(context, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedThemeToggle(BuildContext context, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isVerySmall = availableWidth < 300;
        final isSmall = availableWidth < 400;
        final isTablet = availableWidth > 600;
        double switchHeight,
            switchSpacing,
            iconSize,
            textSize,
            labelSize,
            emojiSize;
        if (isTablet) {
          switchHeight = 50.h;
          switchSpacing = 45.0;
          iconSize = 24.sp;
          textSize = 13.sp;
          labelSize = 16.sp;
          emojiSize = 12.sp;
        } else if (isVerySmall) {
          switchHeight = 32.h;
          switchSpacing = 20.0;
          iconSize = 14.sp;
          textSize = 8.sp;
          labelSize = 11.sp;
          emojiSize = 8.sp;
        } else if (isSmall) {
          switchHeight = 36.h;
          switchSpacing = 28.0;
          iconSize = 18.sp;
          textSize = 10.sp;
          labelSize = 13.sp;
          emojiSize = 9.sp;
        } else {
          switchHeight = 40.h;
          switchSpacing = 35.0;
          iconSize = 20.sp;
          textSize = 11.sp;
          labelSize = 14.sp;
          emojiSize = 10.sp;
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24.w : 16.w,
            vertical: isTablet ? 12.h : 8.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: isVerySmall ? 4 : 3,
                child: AnimatedToggleSwitch<bool>.dual(
                  current: isDark,
                  first: false,
                  second: true,
                  spacing: switchSpacing,
                  height: switchHeight,
                  animationDuration: const Duration(milliseconds: 600),
                  animationCurve: Curves.easeInOutCubic,
                  style: ToggleStyle(
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      isTablet ? 30.r : 25.r,
                    ),
                    indicatorColor: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black26
                            : Colors.grey.withAlpha(51)
,
                        blurRadius: isTablet ? 12 : 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  styleBuilder: (value) => ToggleStyle(
                    backgroundColor: value
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE3F2FD),
                  ),
                  iconBuilder: (value) => value
                      ? Icon(
                          Icons.nightlight_round,
                          color: Colors.amber,
                          size: iconSize,
                        )
                      : Icon(
                          Icons.wb_sunny,
                          color: Colors.orange,
                          size: iconSize,
                        ),
                  textBuilder: (value) => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value ? 'Dark' : 'Light',
                      style: TextStyle(
                        color: value ? Colors.white : Colors.black87,
                        fontSize: textSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(ThemeToggled());
                  },
                ),
              ),
              SizedBox(width: isTablet ? 12.w : (isVerySmall ? 4.w : 8.w)),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        context.translate('mode'),
                        style: TextStyle(
                          fontSize: labelSize,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isVerySmall) ...[
                      SizedBox(height: 2.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isDark ? '🌙 Night' : '☀️ Day',
                          style: TextStyle(
                            fontSize: emojiSize,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        text,
        style: TextStyle(
          fontSize: isTablet ? 12.sp : 15.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onPressed,
    );
  }
}

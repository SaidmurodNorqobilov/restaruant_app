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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {
        return Drawer(
          surfaceTintColor: AppColors.white,
          shadowColor: AppColors.white,
          backgroundColor: isDark ? AppColors.lightText : AppColors.lightDivider,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppIcons.menu,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                      width: 80.w,
                      height: 80.h,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ATS',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w300,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'MENU',
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Language',
                        style: TextStyle(
                          fontSize: 14.sp,
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
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'ru', child: Text('Русский')),
                            DropdownMenuItem(value: 'uz', child: Text('O\'zbek')),
                          ],
                        ),
                        Icon(
                          Icons.language,
                          color: AppColors.primary,
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
                onPressed: () => context.pop(),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: AnimatedToggleSwitch<bool>.dual(
              current: isDark,
              first: false,
              second: true,
              spacing: 35.0,
              height: 40.h,
              animationDuration: const Duration(milliseconds: 600),
              animationCurve: Curves.easeInOutCubic,
              style: ToggleStyle(
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(25.r),
                indicatorColor: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
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
                size: 20.sp,
              )
                  : Icon(Icons.wb_sunny, color: Colors.orange, size: 20.sp),
              textBuilder: (value) => Text(
                value ? 'Dark' : 'Light',
                style: TextStyle(
                  color: value ? Colors.white : Colors.black87,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onChanged: (value) {
                context.read<ThemeBloc>().add(ThemeToggled());
              },
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.translate('mode'),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                isDark ? '🌙 Night' : '☀️ Day',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onPressed,
        required bool isDark,
      }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onPressed,
    );
  }
}
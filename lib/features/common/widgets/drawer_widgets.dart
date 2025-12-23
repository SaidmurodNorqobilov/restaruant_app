import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restaurantapp/core/routing/router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/icons.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/language.dart';
import 'package:restaurantapp/features/common/manager/theme_bloc.dart';
import 'package:restaurantapp/features/common/manager/theme_event.dart';
import 'package:restaurantapp/main.dart';

class DrawerWidgets extends StatefulWidget {
  const DrawerWidgets({super.key});

  @override
  State<DrawerWidgets> createState() => _DrawerWidgetsState();
}

class _DrawerWidgetsState extends State<DrawerWidgets> {
  String currentLang = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language') ?? 'en';
    setState(() {
      currentLang = savedLang;
    });
    localization = AppLocalization(savedLang);
    await localization.load();
    setState(() {});
  }

  Future<void> _saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                  AppIcons.menu,
                  width: 80.w,
                  height: 80.h,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
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
                        color: isDark ? AppColors.white : AppColors.textColor
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      dropdownColor: isDark ? AppColors.darkAppBar : AppColors.white,
                      value: currentLang,
                      underline: const SizedBox(),
                      onChanged: (value) async {
                        if (value == null) return;
                        currentLang = value;
                        localization = AppLocalization(value);
                        await localization.load();
                        await _saveLanguage(value);
                        setState(() {});
                      },
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'ru', child: Text('Русский')),
                        DropdownMenuItem(value: 'uz', child: Text('O\'zbek')),
                      ],
                    ),
                    Icon(Icons.language, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _drawerItem(
            icon: Icons.home,
            text: localization.translate('home'),
            onPressed: () => context.pop(),
          ),
          _drawerItem(
            icon: Icons.restaurant_menu,
            text: localization.translate('menu'),
            onPressed: () => context.go(Routes.menu),
          ),
          _drawerItem(
            icon: Icons.local_offer,
            text: localization.translate('promotions'),
            onPressed: () => context.push(Routes.promotions, extra: 1),
          ),
          _drawerItem(
            icon: FontAwesomeIcons.receipt,
            text: localization.translate('orders'),
            onPressed: () => context.push(Routes.order),
          ),
          const Divider(),
          _drawerItem(
            icon: FontAwesomeIcons.circleInfo,
            text: localization.translate('about'),
            onPressed: () => context.push(Routes.about),
          ),
          _drawerItem(
            icon: Icons.currency_exchange,
            text: localization.translate('refund'),
            onPressed: () => context.push(Routes.refund),
          ),
          _drawerItem(
            icon: FontAwesomeIcons.fileContract,
            text: localization.translate('terms'),
            onPressed: () {},
          ),
          const Divider(),
          _drawerItem(
            icon: FontAwesomeIcons.calendarCheck,
            text: localization.translate('reservation'),
            onPressed: () => context.go(Routes.reservations),
          ),
          _drawerItem(
            icon: FontAwesomeIcons.commentDots,
            text: localization.translate('feedback'),
            onPressed: () {},
          ),
          _buildAnimatedThemeToggle(isDark),
        ],
      ),
    );
  }

  Widget _buildAnimatedThemeToggle(bool isDark) {
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
                    color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              styleBuilder: (value) => ToggleStyle(
                backgroundColor: value ? const Color(0xFF1E293B) : const Color(0xFFE3F2FD),
              ),
              iconBuilder: (value) => value
                  ? Icon(Icons.nightlight_round, color: Colors.amber, size: 20.sp)
                  : Icon(Icons.wb_sunny, color: Colors.orange, size: 20.sp),
              textBuilder: (value) => Text(
                value ? 'Dark' : 'Light',
                style: TextStyle(
                  color: value ? Colors.white : Colors.black87,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onChanged: (value) async {
                context.read<ThemeBloc>().add(ThemeToggled());
                await _saveTheme(value);
              },
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localization.translate('mode'),
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

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
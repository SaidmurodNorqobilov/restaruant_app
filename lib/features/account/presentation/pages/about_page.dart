import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/appbar_widgets.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: context.translate('about')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 33.w,
              vertical: 42.h,
            ),
            child: Column(
              children: [
                Text(
                  context.translate('aboutUs'),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import '../../../../core/widgets/appbar_widgets.dart';

class RefundPolicyPage extends StatefulWidget {
  const RefundPolicyPage({super.key});

  @override
  State<RefundPolicyPage> createState() => _RefundPolicyPageState();
}

class _RefundPolicyPageState extends State<RefundPolicyPage> {

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(
        title: context.translate('refund'),
      ),
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
                  context.translate('refundUs'),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
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

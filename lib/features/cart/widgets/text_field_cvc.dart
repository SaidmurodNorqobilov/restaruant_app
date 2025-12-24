import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/icons.dart';

class TextFieldCardCvc extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;

  const TextFieldCardCvc({
    super.key,
    required this.controller,
    required this.text,
    required this.hintText,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isValid = errorText == null && controller.text.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: isDark ? AppColors.white : AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          style: TextStyle(color: isDark ? AppColors.white : AppColors.textColor),
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxHeight: 52.h, maxWidth: 165.w),
            hintText: hintText,
            errorText: errorText,
            suffixIcon:
                suffixIcon ??
                (isValid
                    ? SvgPicture.asset(
                        AppIcons.correct,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.scaleDown,
                      )
                    : (errorText != null
                          ? SvgPicture.asset(
                              AppIcons.warningCircle,
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.scaleDown,
                            )
                          : null)),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10.r),
            //   borderSide: BorderSide(
            //     color: errorText != null
            //         ? Colors.red
            //         : (isValid ? Colors.green : Colors.grey),
            //   ),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10.r),
            //   borderSide: BorderSide(
            //     color: errorText != null
            //         ? Colors.red
            //         : (isValid ? Colors.green : Colors.blue),
            //   ),
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10.r),
            //   borderSide: const BorderSide(color: Colors.red),
            // ),
            // focusedErrorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10.r),
            //   borderSide: const BorderSide(color: Colors.red),
            // ),
          ),
        ),
      ],
    );
  }
}

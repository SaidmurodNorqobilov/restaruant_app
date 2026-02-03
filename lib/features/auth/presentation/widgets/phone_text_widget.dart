import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class PhoneTextWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool hasError;

  const PhoneTextWidget({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      cursorColor: AppColors.textColor,
      controller: controller,
      keyboardType: TextInputType.phone,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.phone,
          color: isDark ? Colors.grey[400] : Colors.grey[700],
        ),
        hintText: "Telefon raqamingizni kiriting",
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        labelText: "Telefon raqami",
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[300] : Colors.grey[700],
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.red,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
        helperText: hasError ? null : '+998 (XX) XXX-XX-XX',
        helperStyle: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.grey[600],
          fontSize: 12,
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );


  }
}


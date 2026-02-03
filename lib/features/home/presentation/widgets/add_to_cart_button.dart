import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/utils/status.dart';

class AddToCartButton extends StatelessWidget {
  final bool isProductActive;
  final Status status;
  final double currentPrice;
  final VoidCallback onPressed;

  const AddToCartButton({
    super.key,
    required this.isProductActive,
    required this.status,
    required this.currentPrice,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isProductActive
              ? [
            AppColors.primary,
            AppColors.primary.withAlpha(204),
          ]
              : [
            Colors.grey[400]!,
            Colors.grey[500]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isProductActive
            ? [
          BoxShadow(
            color: AppColors.primary.withAlpha(102),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: !isProductActive || status == Status.loading ? null : onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Center(
            child: status == Status.loading
                ? SizedBox(
              width: 24.w,
              height: 24.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isProductActive
                      ? Icons.shopping_cart_outlined
                      : Icons.block,
                  color: Colors.white,
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  isProductActive
                      ? "Savatga qo'shish"
                      : "Tugagan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isProductActive) ...[
                  SizedBox(width: 8.w),
                  Text(
                    " ${currentPrice.toStringAsFixed(0)} SO'M",
                    style: TextStyle(
                      color: Colors.white.withAlpha(230),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
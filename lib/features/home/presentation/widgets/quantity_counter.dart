import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';

class QuantityCounter extends StatelessWidget {
  final int quantity;
  final bool isDark;
  final bool isProductActive;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityCounter({
    super.key,
    required this.quantity,
    required this.isDark,
    required this.isProductActive,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            Icons.remove,
            quantity > 1,
            onDecrement,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          _buildButton(
            Icons.add,
            true,
            onIncrement,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, bool enabled, VoidCallback onTap) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: enabled && isProductActive
            ? AppColors.primary
            : (isDark ? Colors.grey[800] : Colors.grey[300]),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && isProductActive ? onTap : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Icon(
            icon,
            color: enabled && isProductActive
                ? Colors.white
                : Colors.grey[500],
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}
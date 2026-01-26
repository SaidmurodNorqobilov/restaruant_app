import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';

class OrderSummarySection extends StatelessWidget {
  final bool isDark;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;

  const OrderSummarySection({
    super.key,
    required this.isDark,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Buyurtma xulosasi',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _PriceRow(
            label: 'Mahsulotlar',
            amount: subtotal,
            isDark: isDark,
            isTotal: false,
          ),
          SizedBox(height: 8.h),
          _PriceRow(
            label: 'Yetkazish',
            amount: deliveryFee,
            isDark: isDark,
            isTotal: false,
          ),
          SizedBox(height: 8.h),
          _PriceRow(
            label: 'Soliq',
            amount: tax,
            isDark: isDark,
            isTotal: false,
          ),
          SizedBox(height: 12.h),
          Divider(
            color: isDark
                ? AppColors.borderColor.withAlpha(51)
                : AppColors.borderColor,
          ),
          SizedBox(height: 12.h),
          _PriceRow(
            label: 'Jami',
            amount: total,
            isDark: isDark,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDark;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amount,
    required this.isDark,
    required this.isTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isDark
                ? (isTotal ? AppColors.white : Colors.white70)
                : (isTotal ? AppColors.textColor : Colors.grey[700]),
          ),
        ),
        Text(
          '${amount.toStringAsFixed(2)} UZS',
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal
                ? AppColors.primary
                : (isDark ? AppColors.white : AppColors.textColor),
          ),
        ),
      ],
    );
  }
}
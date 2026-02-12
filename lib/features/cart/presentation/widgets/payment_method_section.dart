import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import '../../data/datasources/cart_service.dart';

class PaymentMethodSection extends StatelessWidget {
  final bool isDark;
  final String selectedPaymentMethod;
  final String selectedDeliveryType;
  final Function(String) onPaymentMethodChanged;
  final double? userCoinBalance; // User's current coin balance

  const PaymentMethodSection({
    super.key,
    required this.isDark,
    required this.selectedPaymentMethod,
    required this.selectedDeliveryType,
    required this.onPaymentMethodChanged,
    this.userCoinBalance,
  });

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final totalCoinsNeeded = cartService.getTotalCoins();
    final hasEnoughCoins = userCoinBalance != null && userCoinBalance! >= totalCoinsNeeded;

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
                Icons.payment,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'To\'lov usuli',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Column(
            children: [
              _PaymentOption(
                title: 'Naqd pul',
                value: 'cash',
                icon: Icons.money,
                isDark: isDark,
                isSelected: selectedPaymentMethod == 'cash',
                onTap: () => onPaymentMethodChanged('cash'),
              ),
              SizedBox(height: 16.h),
              _PaymentOption(
                title: 'Online to\'lov',
                value: 'online',
                icon: Icons.account_balance_wallet,
                isDark: isDark,
                isSelected: selectedPaymentMethod == 'online',
                onTap: () => onPaymentMethodChanged('online'),
              ),
              if (selectedDeliveryType != 'delivery') ...[
                SizedBox(height: 12.h),
                _PaymentOption(
                  title: 'Karta orqali',
                  value: 'card',
                  icon: Icons.credit_card,
                  isDark: isDark,
                  isSelected: selectedPaymentMethod == 'card',
                  onTap: () => onPaymentMethodChanged('card'),
                ),
              ],
              SizedBox(height: 12.h),
              _CoinPaymentOption(
                title: "Coin",
                value: 'PAYMENT_COIN',
                icon: Icons.monetization_on,
                isDark: isDark,
                isSelected: selectedPaymentMethod == 'PAYMENT_COIN',
                onTap: () => onPaymentMethodChanged('PAYMENT_COIN'),
                totalCoinsNeeded: totalCoinsNeeded,
                userCoinBalance: userCoinBalance,
                hasEnoughCoins: hasEnoughCoins,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(21)
              : (isDark ? AppColors.black.withAlpha(77) : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark
                ? AppColors.borderColor.withAlpha(51)
                : AppColors.borderColor.withAlpha(77)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              )
                  : null,
            ),
            SizedBox(width: 12.w),
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : Colors.grey[600]),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.white : AppColors.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinPaymentOption extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;
  final double totalCoinsNeeded;
  final double? userCoinBalance;
  final bool hasEnoughCoins;

  const _CoinPaymentOption({
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
    required this.totalCoinsNeeded,
    required this.userCoinBalance,
    required this.hasEnoughCoins,
  });

  @override
  Widget build(BuildContext context) {
    final bool canSelect = userCoinBalance != null && hasEnoughCoins;

    return InkWell(
      onTap: canSelect ? onTap : null,
      borderRadius: BorderRadius.circular(12.r),
      child: Opacity(
        opacity: canSelect ? 1.0 : 0.6,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withAlpha(21)
                : (isDark ? AppColors.black.withAlpha(77) : Colors.grey[50]),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: !canSelect
                  ? Colors.red.withAlpha(128)
                  : isSelected
                  ? AppColors.primary
                  : (isDark
                  ? AppColors.borderColor.withAlpha(51)
                  : AppColors.borderColor.withAlpha(77)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: !canSelect
                            ? Colors.red
                            : isSelected
                            ? AppColors.primary
                            : AppColors.borderColor,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    icon,
                    color: !canSelect
                        ? Colors.red
                        : isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white70 : Colors.grey[600]),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: !canSelect
                          ? Colors.red
                          : isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.white : AppColors.textColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(left: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kerakli coin:',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${totalCoinsNeeded.toStringAsFixed(0)} coin',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.white : AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sizning coinlaringiz:',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                        Text(
                          userCoinBalance != null
                              ? '${userCoinBalance!.toStringAsFixed(0)} coin'
                              : '0 coin',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: hasEnoughCoins
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    if (!canSelect && userCoinBalance != null) ...[
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(26),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 14.sp,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Coinlaringiz yetarli emas',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
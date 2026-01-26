import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutBottomBar extends StatelessWidget {
  final bool isDark;
  final double total;
  final String selectedPaymentMethod;
  final String selectedDeliveryType;
  final GlobalKey<FormState> formKey;

  const CheckoutBottomBar({
    super.key,
    required this.isDark,
    required this.total,
    required this.selectedPaymentMethod,
    required this.selectedDeliveryType,
    required this.formKey,
  });

  Future<void> _handleCheckout(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (selectedDeliveryType == 'delivery') {
        final prefs = await SharedPreferences.getInstance();
        final String? savedAddress = prefs.getString('saved_address');
        final double? lat = prefs.getDouble('saved_lat');
        final double? lng = prefs.getDouble('saved_lng');

        if (savedAddress == null || lat == null || lng == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Iltimos, yetkazib berish manzilini tanlang!'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          context.push(Routes.location);
          return;
        }
        _navigateToPayment(context);
      } else {
        _navigateToPayment(context);
      }
    }
  }

  void _navigateToPayment(BuildContext context) {
    if (selectedPaymentMethod == 'card') {
      context.push(Routes.payment);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Buyurtma tasdiqlandi! To\'lov: $selectedPaymentMethod'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(21),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jami',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      Text(
                        '${total.toStringAsFixed(2)} UZS',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 180.w,
                    child: TextButtonApp(
                      onPressed: () => _handleCheckout(context),
                      width: 403,
                      height: 50,
                      text: "Davom etish",
                      textColor: AppColors.white,
                      buttonColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
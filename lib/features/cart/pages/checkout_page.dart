import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';
import '../../../core/routing/routes.dart';
import '../../Reservations/widgets/text_and_text_field.dart';
import '../../onboarding/widgets/text_button_app.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedDeliveryType = 'delivery';
  String selectedPaymentMethod = 'card';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController tableNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final double subtotal = 120.00;
  final double deliveryFee = 15.00;
  final double tax = 18.00;

  double get total => subtotal + deliveryFee + tax;

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    tableNumberController.dispose();
    super.dispose();
  }

  bool get showDeliveryFields => selectedDeliveryType == 'delivery';
  bool get showTableField =>
      selectedDeliveryType == 'eat_in' || selectedDeliveryType == 'take_away';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: "Checkout"),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: 140.h,
                top: 16.h,
                right: 16.w,
                left: 16.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeliveryTypeSection(isDark),
                  SizedBox(height: 16.h),
                  _buildOrderSummarySection(isDark),
                  SizedBox(height: 16.h),
                  _buildPaymentMethodSection(isDark),
                  SizedBox(height: 16.h),
                  _buildCustomerInfoSection(isDark),
                  SizedBox(height: 46.h),
                ],
              ),
            ),
          ),
          _buildBottomBar(isDark),
        ],
      ),
    );
  }

  Widget _buildDeliveryTypeSection(bool isDark) {
    return Container(
      width: double.infinity,
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
                Icons.delivery_dining,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Buyurtma turi',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildDeliveryChip('Yetkazib berish', 'delivery',
                  Icons.delivery_dining, isDark),
              _buildDeliveryChip(
                  'Restoranda', 'eat_in', Icons.restaurant, isDark),
              _buildDeliveryChip('Olib ketish', 'take_away',
                  Icons.shopping_bag_outlined, isDark),
              _buildDeliveryChip('Drive Through', 'drive_through',
                  Icons.directions_car, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryChip(
      String title, String value, IconData icon, bool isDark) {
    bool isSelected = selectedDeliveryType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDeliveryType = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(21)

              : (isDark
              ? AppColors.black.withAlpha(77)

              : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                fontSize: 14.sp,
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

  Widget _buildOrderSummarySection(bool isDark) {
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
                'Buyurtma xulasasi',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildPriceRow('Mahsulotlar', subtotal, isDark, false),
          SizedBox(height: 8.h),
          _buildPriceRow('Yetkazish', deliveryFee, isDark, false),
          SizedBox(height: 8.h),
          _buildPriceRow('Soliq', tax, isDark, false),
          SizedBox(height: 12.h),
          Divider(
            color: isDark
                ? AppColors.borderColor.withAlpha(51)

                : AppColors.borderColor,
          ),
          SizedBox(height: 12.h),
          _buildPriceRow('Jami', total, isDark, true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, bool isDark, bool isTotal) {
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
            color: isTotal ? AppColors.primary : (isDark ? AppColors.white : AppColors.textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(bool isDark) {
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
          SizedBox(height: 16.h),
          _buildPaymentOption('Karta orqali', 'card', Icons.credit_card, isDark),
          SizedBox(height: 12.h),
          _buildPaymentOption('Naqd pul', 'cash', Icons.money, isDark),
          SizedBox(height: 12.h),
          _buildPaymentOption(
              'Online to\'lov', 'online', Icons.account_balance_wallet, isDark),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      String title, String value, IconData icon, bool isDark) {
    bool isSelected = selectedPaymentMethod == value;
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(21)

              : (isDark
              ? AppColors.black.withAlpha(77)

              : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark
                ? AppColors.borderColor.withAlpha(51)

                : AppColors.borderColor.withAlpha(77)
),
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

  Widget _buildCustomerInfoSection(bool isDark) {
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
                Icons.person_outline,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Ma\'lumotlar',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          TextAndTextField(
            controller: nameController,
            text: 'Ism',
            hintText: 'Ismingizni kiriting',
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Iltimos, ismingizni kiriting';
            //   }
            //   return null;
            // },
          ),
          SizedBox(height: 16.h),
          TextAndTextField(
            controller: phoneController,
            text: 'Telefon raqam',
            hintText: '+998 __ ___ __ __',
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Iltimos, telefon raqamingizni kiriting';
            //   }
            //   return null;
            // },
          ),
          if (showDeliveryFields) ...[
            SizedBox(height: 16.h),
            TextAndTextField(
              controller: locationController,
              text: 'Manzil',
              hintText: 'Yetkazish manzilini kiriting',
              // validator: (value) {
              //   if (showDeliveryFields &&
              //       (value == null || value.isEmpty)) {
              //     return 'Iltimos, manzilni kiriting';
              //   }
              //   return null;
              // },
            ),
          ],
          if (showTableField) ...[
            SizedBox(height: 16.h),
            TextAndTextField(
              controller: tableNumberController,
              text: 'Stol raqami',
              hintText: 'Stol raqamini kiriting',
              // validator: (value) {
              //   if (showTableField && (value == null || value.isEmpty)) {
              //     return 'Iltimos, stol raqamini kiriting';
              //   }
              //   return null;
              // },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isDark) {
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
              color: Colors.black.withAlpha(21)
,
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
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedPaymentMethod == 'card') {
                            context.push(Routes.payment);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Buyurtma tasdiqlandi! To\'lov: $selectedPaymentMethod'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        }
                      },
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

  void _showLogoutDialog(BuildContext context, bool isDark, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(128)
,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 20.h,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 30.h),
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77)
,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(51)
,
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 50.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 30.h),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withAlpha(179)
,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    context.translate('register'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.translate('auth_required_before_order'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.white.withOpacity(0.8)
                        : AppColors.black.withAlpha(179)
,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 45.h),
                Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(77)
,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.login);
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: AppColors.white,
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              context.translate('enter'),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77)
,
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          context.translate('cancel'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
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
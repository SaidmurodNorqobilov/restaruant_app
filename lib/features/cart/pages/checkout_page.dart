import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/utils/colors.dart';
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
  String selectedOption = 'delivery';
  List selectPaymentMode = ['Card', 'Cash', 'Online payment'];
  int selectMode = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: "Checkout"),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 120.h,
                top: 20.h,
                right: 12.w,
                left: 12.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkAppBar : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How would you like to receive your items?',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.white : AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: [
                            _buildRadioOption('Delivery', 'delivery'),
                            _buildRadioOption('Eat in', 'eat_in'),
                            _buildRadioOption('Drive Through', 'drive_through'),
                            _buildRadioOption('Take away', 'take_away'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 11.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkAppBar : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.white : AppColors.textColor,
                                fontSize: 16.sp,
                              ),
                            ),
                            Text(
                              'AED 153.00',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.white : AppColors.textColor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        const Divider(),
                        SizedBox(height: 10.h),
                        Text(
                          'Select payment mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.white : AppColors.textColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Column(
                          children: List.generate(selectPaymentMode.length, (index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectMode = index;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: selectMode == index
                                              ? AppColors.primary
                                              : AppColors.borderColor,
                                          width: 2.w,
                                        ),
                                      ),
                                      child: selectMode == index
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
                                    Text(
                                      selectPaymentMode[index],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: selectMode == index
                                            ? AppColors.primary
                                            : (isDark ? Colors.white70 : AppColors.textColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 11.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 16.w,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkAppBar : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        TextAndTextField(
                          controller: nameController,
                          text: 'Name',
                          hintText: 'Enter your name',
                        ),
                        SizedBox(height: 12.h),
                        TextAndTextField(
                          controller: emailController,
                          text: 'Location',
                          hintText: 'Enter your address',
                        ),
                        SizedBox(height: 12.h),
                        TextAndTextField(
                          controller: phoneNumberController,
                          text: 'Phone Number',
                          hintText: 'Enter phone number',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 24.w,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkAppBar : AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10.r,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: TextButtonApp(
                  onPressed: () {
                    context.push(Routes.address);
                  },
                  width: 403,
                  height: 50,
                  text: "Continue",
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = selectedOption == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : AppColors.borderColor),
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.white : AppColors.primary,
                  ),
                ),
              )
                  : null,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
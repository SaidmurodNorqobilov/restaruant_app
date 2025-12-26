import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';

import '../../../core/routing/routes.dart';
import '../../../core/utils/colors.dart';
import '../../Reservations/widgets/text_and_text_field.dart';
import '../../onboarding/widgets/text_button_app.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController houseController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    buildingController.dispose();
    houseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: 'Address'),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 35.h),
                    Text(
                      'Enter your delivery address',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 24.h,
                        horizontal: 16.w,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkAppBar : AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextAndTextField(
                            controller: addressController,
                            text: 'Address',
                            hintText: 'Enter street address',
                          ),
                          SizedBox(height: 16.h),
                          TextAndTextField(
                            controller: buildingController,
                            text: 'Building Name',
                            hintText: 'Enter building name',
                          ),
                          SizedBox(height: 16.h),
                          TextAndTextField(
                            controller: houseController,
                            text: 'House Number',
                            hintText: 'Enter villa/apartment number',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
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
                child: TextButtonApp(
                  onPressed: () {
                    context.push(Routes.payment);
                  },
                  width: 403,
                  height: 50,
                  text: "Proceed to payment",
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

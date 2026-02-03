import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/appbar_widgets.dart';
import '../../../onboarding/presentation/widgets/text_button_app.dart';
import '../../../reservations/presentation/widgets/text_and_text_field.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    addressController.dispose();
    buildingController.dispose();
    houseController.dispose();
    floorController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: 'Manzil ma\'lumotlari'),
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 16.h,
                  bottom: 100.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 28.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Yetkazish manzili',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: isDark
                                ? AppColors.white
                                : AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkAppBar : AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(8),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextAndTextField(
                            controller: addressController,
                            text: 'Ko\'cha nomi',
                            hintText: 'Masalan: Amir Temur ko\'chasi',
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Iltimos, ko\'cha nomini kiriting';
                            //   }
                            //   return null;
                            // },
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextAndTextField(
                                  controller: buildingController,
                                  text: 'Bino',
                                  hintText: 'Bino nomi',
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Bino nomini kiriting';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextAndTextField(
                                  controller: houseController,
                                  text: 'Uy/Kvartira',
                                  hintText: 'Raqam',
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Raqamni kiriting';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          TextAndTextField(
                            controller: floorController,
                            text: 'Qavat (ixtiyoriy)',
                            hintText: 'Qavat raqami',
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          TextAndTextField(
                            controller: notesController,
                            text: 'Qo\'shimcha ma\'lumot (ixtiyoriy)',
                            hintText: 'Masalan: Eshik rangi, bino yonidagi mo\'ljal',
                            // maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
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
                  child: TextButtonApp(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.push(Routes.payment);
                      }
                    },
                    width: 403,
                    height: 50,
                    text: "To'lovga o'tish",
                    textColor: AppColors.white,
                    buttonColor: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

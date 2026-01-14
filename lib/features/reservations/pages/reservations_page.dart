import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/Reservations/widgets/text_and_text_field.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/menu/widgets/app_bar_home.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController reservationTimeController =
      TextEditingController();
  final TextEditingController specialController = TextEditingController();
  final TextEditingController dateController = TextEditingController();


  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    reservationTimeController.dispose();
    specialController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBarHome(
        title: Text(context.translate('reservation')),
      ),
      drawer: const DrawerWidgets(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.translate('reserveYourTable'),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.translate('viewMyReservations'),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textColor,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkAppBar : AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextAndTextField(
                      controller: nameController,
                      text: context.translate('name'),
                      hintText: context.translate('inputName'),
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: emailController,
                      text: 'Email',
                      hintText: context.translate('email'),
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: phoneNumberController,
                      text: context.translate('phoneNumber'),
                      hintText: context.translate('inputNumber'),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      context.translate('numberOfGuests'),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      width: 160.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        color: isDark
                            ? Colors.blueGrey
                            : AppColors.backgroundLightColor,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 20,
                            color: AppColors.white,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                isExpanded: true,
                                dropdownColor: isDark
                                    ? AppColors.darkAppBar
                                    : AppColors.primary,
                                value: currentPerson,
                                onChanged: (value) =>
                                    setState(() => currentPerson = value!),
                                items: personList.map((person) {
                                  return DropdownMenuItem<int>(
                                    value: person.value,
                                    child: Text(
                                      person.label,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        picker.DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          onConfirm: (date) {
                            setState(() {
                              reservationTimeController.text =
                                  "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                            });
                          },
                          locale: picker.LocaleType.en,
                          theme: picker.DatePickerTheme(
                            backgroundColor: isDark
                                ? AppColors.darkAppBar
                                : Colors.white,
                            itemStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            doneStyle: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        child: TextAndTextField(
                          controller: reservationTimeController,
                          text: context.translate('reservationTime'),
                          hintText: context.translate('enterTime'),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: specialController,
                      text: context.translate('specialNote'),
                      hintText: context.translate('specialNote'),
                    ),
                    SizedBox(height: 15.h),
                    TextAndTextField(
                      controller: dateController,
                      text: context.translate('date'),
                      hintText: context.translate('autofillDate'),
                      prefixIcon: InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: isDark
                                      ? const ColorScheme.dark(
                                          primary: AppColors.primary,
                                          onPrimary: Colors.white,
                                          surface: AppColors.darkAppBar,
                                          onSurface: Colors.white,
                                        )
                                      : const ColorScheme.light(
                                          primary: AppColors.primary,
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                          onSurface: AppColors.textColor,
                                        ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dateController.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                            });
                          }
                        },
                        child: const Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: TextButtonApp(
                  width: 272,
                  height: 50,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          height: isTablet
                              ? MediaQuery.of(context).size.height * 0.65
                              : MediaQuery.of(context).size.height * 0.55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      AppColors.black.withOpacity(0.9),
                                      AppColors.black.withOpacity(0.8),
                                    ]
                                  : [
                                      AppColors.white.withOpacity(0.9),
                                      AppColors.white.withOpacity(0.8),
                                    ],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.r),
                              topRight: Radius.circular(30.r),
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5.w,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 30.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 50.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                SizedBox(height: 35.h),
                                Container(
                                  width: 100.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary.withOpacity(0.2),
                                        AppColors.primary.withOpacity(0.05),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.2,
                                        ),
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
                                      AppColors.primary.withOpacity(0.7),
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    "hozircha ishlamaydi",
                                    // 'Ro\'yxatdan o\'ting',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                // Text(
                                //   'Bron qilishdan oldin tizimga kirishingiz yoki ro\'yxatdan o\'tishingiz kerak',
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     fontSize: 14.sp,
                                //     fontWeight: FontWeight.w400,
                                //     color: isDark
                                //         ? AppColors.white.withOpacity(0.8)
                                //         : AppColors.black.withOpacity(0.7),
                                //     height: 1.6,
                                //   ),
                                // ),
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
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
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
                                        // context.push(Routes.login);
                                      },
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.login_rounded,
                                              color: AppColors.white,
                                              size: 22.sp,
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              "Yaxshilab bekor qilish )))",
                                              // 'Kirish',
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
                                      color: AppColors.primary.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15.r),
                                      onTap: () => Navigator.pop(context),
                                      child: Center(
                                        child: Text(
                                          'Bekor qilish',
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
                  },
                  text: context.translate('submit'),
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonOption {
  final int value;
  final String label;

  PersonOption(this.value, this.label);
}

List<PersonOption> personList = [
  PersonOption(1, '1 person'),
  PersonOption(2, '2 persons'),
  PersonOption(3, '3 (max)'),
];

int currentPerson = 3;

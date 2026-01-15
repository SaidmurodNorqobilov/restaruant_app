import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/data/repositories/reservations_repository.dart';
import 'package:restaurantapp/features/Reservations/widgets/text_and_text_field.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_bloc.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_state.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/menu/widgets/app_bar_home.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:restaurantapp/features/reservations/managers/reservation_bloc.dart';
import 'package:restaurantapp/features/reservations/managers/reservation_state.dart';
import '../../../core/utils/status.dart';
import 'my_reservation_page.dart';

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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    reservationTimeController.dispose();
    specialController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSuccessDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.darkAppBar,
                        AppColors.black.withAlpha(230),
                      ]
                    : [
                        AppColors.white,
                        AppColors.white.withOpacity(0.95),
                      ],
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AppColors.primary.withAlpha(77),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(51),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withAlpha(179),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(77),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 50.sp,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Muvaffaqiyatli!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Buyurtmangiz qabul qilindi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.white.withAlpha(179)
                        : AppColors.textColor.withAlpha(179),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary.withAlpha(77),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () => Navigator.pop(dialogContext),
                            child: Center(
                              child: Text(
                                'Yopish',
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
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(77),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              Navigator.pop(dialogContext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyReservationsPage(),
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                'Ko\'rish',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context, bool isDark, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BackdropFilter(
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
                      AppColors.black.withAlpha(230),
                      AppColors.black.withOpacity(0.8),
                    ]
                  : [
                      AppColors.white.withAlpha(230),
                      AppColors.white.withOpacity(0.8),
                    ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
            border: Border.all(
              color: Colors.white.withAlpha(51),
              width: 1.5.w,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(128),
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
                        AppColors.primary.withAlpha(51),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(51),
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
                      AppColors.primary.withAlpha(179),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Ro\'yxatdan o\'ting',
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
                  'Bron qilishdan oldin tizimga kirishingiz yoki ro\'yxatdan o\'tishingiz kerak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.white.withOpacity(0.8)
                        : AppColors.black.withAlpha(179),
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
                        color: AppColors.primary.withAlpha(77),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () => Navigator.pop(modalContext),
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
                              'Kirish',
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
                      color: AppColors.primary.withAlpha(77),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () => Navigator.pop(modalContext),
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
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBarHome(title: Text(context.translate('reservation'))),
      drawer: const DrawerWidgets(),
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userState) => SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: BlocProvider(
              create: (context) => ReservationBloc(
                repository: ReservationRepository(client: ApiClient()),
              ),
              child: BlocConsumer<ReservationBloc, ReservationState>(
                listener: (context, state) {
                  if (state.status == Status.success) {
                    nameController.clear();
                    emailController.clear();
                    phoneNumberController.clear();
                    reservationTimeController.clear();
                    specialController.clear();
                    setState(() => currentPerson = 3);
                    _showSuccessDialog(context, isDark);
                  } else if (state.status == Status.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage ?? 'Xatolik yuz berdi',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            context.translate('reserveYourTable'),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyReservationsPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.list_alt,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          label: Text(
                            'Mening\nbronlarim',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 24.h,
                        horizontal: 16.w,
                      ),
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
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
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
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      isExpanded: true,
                                      dropdownColor: isDark
                                          ? AppColors.darkAppBar
                                          : AppColors.primary,
                                      value: currentPerson,
                                      onChanged: (value) => setState(
                                        () => currentPerson = value!,
                                      ),
                                      items: personList
                                          .map(
                                            (person) => DropdownMenuItem<int>(
                                              value: person.value,
                                              child: Text(
                                                person.label,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.h),
                          GestureDetector(
                            onTap: () {
                              picker.DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                onConfirm: (date) {
                                  setState(() {
                                    reservationTimeController.text = date
                                        .toIso8601String();
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
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: TextButtonApp(
                        width: 272,
                        height: 50,
                        onPressed: () {
                          if (userState.user == null) {
                            _showLoginDialog(context, isDark, isTablet);
                          } else {
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                phoneNumberController.text.isEmpty ||
                                reservationTimeController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  showCloseIcon: true,
                                  content: Text(
                                    'Iltimos, barcha maydonlarni to\'ldiring',
                                  ),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            if (!isValidEmail(emailController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Haqiqiy email manzili kiriting!',
                                  ),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                  showCloseIcon: true,
                                ),
                              );
                              return;
                            }
                            context.read<ReservationBloc>().add(
                              AddReservationEvent(
                                name: nameController.text,
                                email: emailController.text,
                                phoneNumber: phoneNumberController.text,
                                numberOfGuests: currentPerson,
                                reservationTime: reservationTimeController.text,
                                specialNote: specialController.text,
                                isActive: true,
                              ),
                            );
                          }
                        },
                        text: state.status == Status.loading
                            ? 'Yuborilmoqda...'
                            : context.translate('submit'),
                        textColor: AppColors.white,
                        buttonColor: state.status == Status.loading
                            ? AppColors.primary.withOpacity(0.6)
                            : AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
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

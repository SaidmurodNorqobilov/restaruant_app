import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/features/Reservations/pages/my_reservation_page.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/status.dart';
import '../../../core/utils/localization_extension.dart';
import '../../onboarding/widgets/text_button_app.dart';
import '../managers/reservation_bloc.dart';
import '../managers/reservation_state.dart';

class ReservationSubmitButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final TextEditingController reservationTimeController;
  final TextEditingController specialController;
  final int currentPerson;
  final bool isDark;
  final bool isTablet;
  final dynamic userState;

  const ReservationSubmitButton({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneNumberController,
    required this.reservationTimeController,
    required this.specialController,
    required this.currentPerson,
    required this.isDark,
    required this.isTablet,
    required this.userState,
  });

  String? _validateName(String name) {
    if (name.isEmpty) {
      return 'Ism kiriting';
    }
    if (name.length < 3) {
      return 'Ism kamida 3 ta belgidan iborat bo\'lishi kerak';
    }
    if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ\s]+$').hasMatch(name)) {
      return 'Ism faqat harflardan iborat bo\'lishi kerak';
    }
    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email kiriting';
    }

    if (!email.contains('@')) {
      return 'Email @ belgisini o\'z ichiga olishi kerak';
    }

    String username = email.split('@')[0];
    if (username.length < 5) {
      return 'Email nomi kamida 5 ta belgidan iborat bo\'lishi kerak';
    }

    if (!email.toLowerCase().endsWith('@gmail.com')) {
      return 'Faqat @gmail.com manzillar qabul qilinadi';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]{5,}@gmail\.com$');
    if (!emailRegex.hasMatch(email.toLowerCase())) {
      return 'Email formati noto\'g\'ri';
    }

    return null;
  }

  String? _validatePhoneNumber(String phone) {
    if (phone.isEmpty) {
      return 'Telefon raqam kiriting';
    }

    if (!phone.startsWith('+998')) {
      return 'Telefon raqam +998 bilan boshlanishi kerak';
    }

    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleanPhone.length != 13) {
      return 'Telefon raqam 13 ta belgidan iborat bo\'lishi kerak (+998XXXXXXXXX)';
    }

    String operatorCode = cleanPhone.substring(4, 6);
    List<String> validCodes = [
      '90',
      '91',
      '93',
      '94',
      '95',
      '97',
      '98',
      '99',
      '33',
      '88',
      '77',
    ];

    if (!validCodes.contains(operatorCode)) {
      return 'Noto\'g\'ri operator kodi';
    }

    return null;
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _showSuccessDialog(BuildContext parentContext, bool isDark) {
    showDialog(
      context: parentContext,
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
                    ? [AppColors.darkAppBar, AppColors.black.withAlpha(230)]
                    : [AppColors.white, AppColors.white.withOpacity(0.95)],
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
                  'Buyurtmangiz yuborildi',
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
                            onTap: () => Navigator.of(dialogContext).pop(),
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
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.push(
                                dialogContext,
                                MaterialPageRoute(
                                  builder: (context) => MyReservationsPage(),
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
          width: double.infinity,
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
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Column(
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
                Icon(
                  Icons.person_outline_rounded,
                  size: 80.sp,
                  color: AppColors.primary,
                ),
                SizedBox(height: 30.h),
                Text(
                  'Ro\'yxatdan o\'ting',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Bron qilishdan oldin tizimga kirishingiz kerak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const Spacer(),
                TextButtonApp(
                  text: 'Kirish',
                  onPressed: () => Navigator.pop(modalContext),
                  width: 272,
                  height: 50,
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
                SizedBox(height: 22.h),
                TextButton(
                  onPressed: () => Navigator.pop(modalContext),
                  child: Text(
                    'Bekor qilish',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state.status == Status.success) {
          nameController.clear();
          emailController.clear();
          phoneNumberController.clear();
          reservationTimeController.clear();
          specialController.clear();
          _showSuccessDialog(context, isDark);
        } else if (state.status == Status.error) {
          _showErrorSnackBar(context, state.errorMessage ?? 'Xatolik!');
        }
      },
      builder: (context, state) {
        return Center(
          child: TextButtonApp(
            width: 272,
            height: 50,
            onPressed: () {
              if (userState.user == null) {
                _showLoginDialog(context, isDark, isTablet);
                return;
              }

              final nameError = _validateName(nameController.text);
              if (nameError != null) {
                _showErrorSnackBar(context, nameError);
                return;
              }

              final emailError = _validateEmail(emailController.text);
              if (emailError != null) {
                _showErrorSnackBar(context, emailError);
                return;
              }

              final phoneError = _validatePhoneNumber(
                phoneNumberController.text,
              );
              if (phoneError != null) {
                _showErrorSnackBar(context, phoneError);
                return;
              }

              if (reservationTimeController.text.isEmpty) {
                _showErrorSnackBar(context, 'Bron vaqtini tanlang');
                return;
              }

              context.read<ReservationBloc>().add(
                AddReservationEvent(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneNumberController.text,
                  numberOfGuests: currentPerson,
                  reservationTime: reservationTimeController.text,
                  specialNote: specialController.text,
                  isActive: true,
                ),
              );
            },
            text: state.status == Status.loading
                ? 'Yuborilmoqda...'
                : context.translate('submit'),
            textColor: AppColors.white,
            buttonColor: state.status == Status.loading
                ? AppColors.primary.withOpacity(0.6)
                : AppColors.primary,
          ),
        );
      },
    );
  }
}

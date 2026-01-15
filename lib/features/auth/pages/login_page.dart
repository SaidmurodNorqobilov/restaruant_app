import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

import '../managers/authCubit/auth_cubit.dart';
import '../managers/authCubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final rawPhone = phoneController.text.replaceAll(RegExp(r'\s+'), '');
      final fullPhoneNumber = '+998$rawPhone';
      context.read<AuthCubit>().sendPhone(fullPhoneNumber);
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == Status.success && state.sessionId != null) {
                context.push(Routes.otpSms, extra: state.sessionId);
              } else if (state.status == Status.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Xatolik yuz berdi'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Kirish",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Telefon raqamingizni kiriting",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 62.h),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                      cursorColor: AppColors.textColor,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 10.w),
                          child: Text(
                            '+998',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        hintText: 'XX XXX XX XX',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),

                        filled: true,
                        fillColor: isDark ? AppColors.darkAppBar.withAlpha(128)
 : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide(color: Colors.red, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.replaceAll(RegExp(r'\s+'), '').length != 9) {
                          return "Raqam 9 xonali bo'lishi kerak";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    state.status == Status.loading
                        ? const CircularProgressIndicator()
                        : TextButtonApp(
                      height: 58,
                      width: 403,
                      onPressed: () => _register(context),
                      text: "Kodni olish",
                      textColor: AppColors.white,
                      buttonColor: AppColors.primary,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

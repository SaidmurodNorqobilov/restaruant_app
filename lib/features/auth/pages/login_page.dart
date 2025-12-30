import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/auth/widgets/phone_text_widget.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';

import '../widgets/phone_validation_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();

  bool _hasError = false;
  final _formKey = GlobalKey<FormState>();

  void _register(BuildContext context) {
    setState(() {
      _hasError = !(_formKey.currentState?.validate() ?? false);
    });

    if (_hasError) return;

    final rawPhone = phoneController.text.trim();
    final phone = PhoneValidatsiyaWidget.formatPhone(rawPhone);

    if (!PhoneValidatsiyaWidget.isValidUzbekPhone(phone)) {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Noto\'g\'ri telefon raqam'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.push(Routes.otpSms);
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
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ro\'yxatdan o\'tish",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(
                  height: 62.h,
                ),
                PhoneTextWidget(
                  controller: phoneController,
                  hasError: _hasError,
                  validator: PhoneValidatsiyaWidget.validate,
                  onChanged: (value) {
                    if (_hasError) {
                      setState(() {
                        _hasError = false;
                      });
                      _formKey.currentState?.validate();
                    }
                  },
                ),
                SizedBox(
                  height: 23.h,
                ),
                TextButtonApp(
                  height: 58,
                  width: 380,
                  onPressed: () => _register(context),
                  text: "Ro\'yxatdan o\'tish",
                  textColor: AppColors.white,
                  buttonColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
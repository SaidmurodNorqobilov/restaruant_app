import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/utils/colors.dart';
import '../../common/widgets/secces_page.dart';

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvcController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  String _formatExpiryDate(String value) {
    value = value.replaceAll('/', '');
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: 'To\'lov ma\'lumotlari'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withAlpha(179)
,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(77)
,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: Colors.white,
                          size: 32.sp,
                        ),
                        Text(
                          'VISA',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      cardNumberController.text.isEmpty
                          ? '**** **** **** ****'
                          : _formatCardNumber(cardNumberController.text),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KARTA EGASI',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              nameController.text.isEmpty
                                  ? 'ISM FAMILIYA'
                                  : nameController.text.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AMAL QILISH MUDDATI',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              expiryDateController.text.isEmpty
                                  ? 'MM/YY'
                                  : expiryDateController.text,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
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
                  children: [
                    TextFormField(
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Karta egasi',
                        hintText: 'Ism Familiya',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.borderColor.withAlpha(51)

                                : AppColors.borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Iltimos, ismingizni kiriting';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.textColor,
                      ),
                      controller: cardNumberController,
                      decoration: InputDecoration(
                        labelText: 'Karta raqami',
                        hintText: '**** **** **** ****',
                        prefixIcon: Icon(
                          Icons.credit_card,
                          color: AppColors.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.borderColor.withAlpha(51)

                                : AppColors.borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Iltimos, karta raqamini kiriting';
                        }
                        if (value.length < 16) {
                          return 'Karta raqami 16 ta raqamdan iborat bo\'lishi kerak';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                            controller: expiryDateController,
                            decoration: InputDecoration(
                              labelText: 'Amal qilish muddati',
                              hintText: 'MM/YY',
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: AppColors.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: isDark
                                      ? AppColors.borderColor.withAlpha(51)

                                      : AppColors.borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onChanged: (value) {
                              if (value.length == 4) {
                                expiryDateController.text = _formatExpiryDate(
                                  value,
                                );
                                expiryDateController
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset: expiryDateController.text.length,
                                  ),
                                );
                              }
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Muddatni kiriting';
                              }
                              if (value.length < 4) {
                                return 'MM/YY formatida kiriting';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: TextFormField(
                            controller: cvcController,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                            decoration: InputDecoration(
                              labelText: 'CVV/CVC',
                              hintText: '***',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.textColor,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: AppColors.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: isDark
                                      ? AppColors.borderColor.withAlpha(51)

                                      : AppColors.borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'CVV kiriting';
                              //   }
                              //   if (value.length < 3) {
                              //     return '3 ta raqam';
                              //   }
                              //   return null;
                              // },
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    TextButtonApp(
                      width: 403,
                      height: 50,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SuccessPage(
                                message:
                                    "To'lovingiz muvaffaqiyatli amalga oshirildi",
                                appbarTitle: 'To\'lov tasdiqlandi',
                              ),
                            ),
                          );
                        }
                      },
                      text: 'To\'lash',
                      textColor: AppColors.white,
                      buttonColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

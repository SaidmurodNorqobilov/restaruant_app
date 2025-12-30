import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/utils/colors.dart';

import '../../../core/routing/routes.dart';
import '../widgets/custom_drop_down_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/profile_avatar_widget.dart';

class ProfileSignPage extends StatefulWidget {
  const ProfileSignPage({super.key});

  @override
  State<ProfileSignPage> createState() => _ProfileSignPageState();
}

class _ProfileSignPageState extends State<ProfileSignPage> {
  final ismController = TextEditingController();
  final familiyaController = TextEditingController();
  String? tanlanganViloyat;
  File? rasm;

  final viloyatlar = {
    'Toshkent': 1,
    'Samarqand': 2,
    'Farg\'ona': 3,
    'Buxoro': 4,
    'Namangan': 5,
    'Xorazm': 6,
    'Qashqadaryo': 7,
    'Surxondaryo': 8,
    'Andijon': 9,
    'Jizzax': 10,
    'Navoiy': 11,
    'Sirdaryo': 12,
    'Qoraqalpog\'iston': 13,
  };

  Future<void> _rasmTanlash() async {
    final picker = ImagePicker();
    final tanlangan = await picker.pickImage(source: ImageSource.gallery);
    if (tanlangan != null) {
      setState(() {
        rasm = File(tanlangan.path);
      });
    }
  }

  bool _validateForm() {
    if (ismController.text.trim().isEmpty) {
      _showError('Ismingizni kiriting');
      return false;
    }
    if (familiyaController.text.trim().isEmpty) {
      _showError('Familyangizni kiriting');
      return false;
    }
    if (tanlanganViloyat == null) {
      _showError('Viloyatingizni tanlang');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ismController.dispose();
    familiyaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.white : AppColors.black,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Profilingizni to\'ldiring',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Ma\'lumotlaringizni kiriting',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.white.withOpacity(0.7)
                        : AppColors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 40.h),

                ProfileAvatarWidget(
                  imageFile: rasm,
                  onTap: _rasmTanlash,
                ),
                SizedBox(height: 40.h),
                CustomTextFeldWidget(
                  controller: ismController,
                  hintText: "Ismingiz",
                ),
                SizedBox(height: 16.h),

                CustomTextFeldWidget(
                  controller: familiyaController,
                  hintText: "Familyangiz",
                ),
                SizedBox(height: 16.h),

                CustomDropDownWidget(

                  value: tanlanganViloyat,
                  hintText: "Viloyatingiz",
                  items: viloyatlar.keys
                      .map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v),
                  ))
                      .toList(),
                  onChanged: (yangi) => setState(() => tanlanganViloyat = yangi),
                ),
                SizedBox(height: 60.h),

                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateForm()) {
                        context.go(Routes.home);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    child: Text(
                      'Saqlash',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
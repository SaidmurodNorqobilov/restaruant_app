import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_bloc.dart';
import '../../../core/routing/routes.dart';
import '../managers/authCubit/auth_cubit.dart';
import '../managers/profileCubit/profile_cubit.dart';
import '../managers/profileCubit/profile_state.dart';
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
  final phoneNumberController = TextEditingController();
  String? tanlanganViloyat;
  File? rasm;

  final viloyatlar = {
    "andijon": "Andijon",
    "buxoro": "Buxoro",
    "fargona": "Farg‘ona",
    "jizzax": "Jizzax",
    "xorazm": "Xorazm",
    "namangan": "Namangan",
    "navoiy": "Navoiy",
    "qashqadaryo": "Qashqadaryo",
    "qoraqalpogiston": "Qoraqalpog‘iston Respublikasiiii",
    "samarqand": "Samarqand",
    "sirdaryo": "Sirdaryo",
    "surxondaryo": "Surxondaryo",
    "toshkent_viloyati": "Toshkent viloyati",
    "toshkent_shahri": "Toshkent shahri",
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

  void _saveProfile(BuildContext context) {
    if (!_validateForm()) return;

    final userState = context.read<UserProfileBloc>().state;
    // final phoneNum = phoneNumberController.text.trim();
    if(phoneNumberController.text.isEmpty && userState.user != null){
      phoneNumberController.text = userState.user!.phone;
    }

    if (phoneNumberController.text.isEmpty) {
      _showError('Telefon raqami topilmadi');
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      firstName: ismController.text.trim(),
      lastName: familiyaController.text.trim(),
      phone: phoneNumberController.text.trim(),
      address: tanlanganViloyat!,
      imageFile: rasm,
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
      backgroundColor:  AppColors.white,
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
            child: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state.status == Status.success) {
                  context.read<UserProfileBloc>().add(GetUserProfile());
                  context.go(Routes.home);
                } else if (state.status == Status.error) {
                  _showError( 'Xatolik yuz berdi');
                }
              },
              builder: (context, state) {
                return Column(
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
                      items: viloyatlar.entries
                          .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ))
                          .toList(),
                      onChanged: (yangi) => setState(() => tanlanganViloyat = yangi),
                    ),
                    SizedBox(height: 60.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: state.status == Status.loading
                            ? null
                            : () => _saveProfile(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: state.status == Status.loading
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : Text(
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
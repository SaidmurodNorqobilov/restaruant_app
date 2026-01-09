import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../core/routing/routes.dart';
import '../../auth/managers/profileCubit/profile_cubit.dart';
import '../../auth/managers/profileCubit/profile_state.dart';
import '../../auth/widgets/custom_drop_down_widget.dart';
import '../../auth/widgets/custom_text_field_widget.dart';
import '../managers/user_profile_bloc.dart';
import '../managers/user_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ismController = TextEditingController();
  final familiyaController = TextEditingController();
  String? tanlanganViloyat;
  File? rasm;
  String? networkImageUrl;
  final phoneNumberController = TextEditingController();
  bool _isInitialized = false;

  final viloyatlar = {
    "andijon": "Andijon",
    "buxoro": "Buxoro",
    "fargona": "Farg'ona",
    "jizzax": "Jizzax",
    "xorazm": "Xorazm",
    "namangan": "Namangan",
    "navoiy": "Navoiy",
    "qashqadaryo": "Qashqadaryo",
    "qoraqalpogiston": "Qoraqalpog'iston Respublikasiiii",
    "samarqand": "Samarqand",
    "sirdaryo": "Sirdaryo",
    "surxondaryo": "Surxondaryo",
    "toshkent_viloyati": "Toshkent viloyati",
    "toshkent_shahri": "Toshkent shahri",
  };

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(GetUserProfile());
  }

  Future<void> _rasmTanlash() async {
    final picker = ImagePicker();
    final tanlangan = await picker.pickImage(source: ImageSource.gallery);
    if (tanlangan != null) {
      setState(() {
        rasm = File(tanlangan.path);
        networkImageUrl = null;
      });
    }
  }

  bool _validateForm() {
    if (ismController.text
        .trim()
        .isEmpty) {
      _showError('Ismingizni kiriting');
      return false;
    }
    if (familiyaController.text
        .trim()
        .isEmpty) {
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
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

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
            child: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, profileState) {
                if (profileState.status == Status.success) {
                  context.read<UserProfileBloc>().add(GetUserProfile());
                  context.go(Routes.home);
                } else if (profileState.status == Status.error) {
                  _showError(profileState.errorMessage ?? 'Xatolik yuz berdi');
                }
              },
              builder: (context, profileState) {
                return BlocBuilder<UserProfileBloc, UserProfileState>(
                  builder: (context, userState) {
                    if (!_isInitialized && userState.user != null) {
                      _isInitialized = true;
                      ismController.text = userState.user!.firstName;
                      familiyaController.text = userState.user!.lastName;
                      final region = userState.user!.address;
                      tanlanganViloyat = viloyatlar.containsKey(region)
                          ? region
                          : null;
                      phoneNumberController.text = userState.user!.phone;

                      if (userState.user!.image != null &&
                          userState.user!.image!.isNotEmpty) {
                        networkImageUrl = userState.user!.image;
                      }
                    }
                    if (userState.status == Status.loading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 60.w,
                                    height: 60.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.restaurant_menu,
                                    size: 28.sp,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'Mahsulotlar yuklanmoqda...',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.white.withOpacity(0.7)
                                    : AppColors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          context.translate("editProfile"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.translate('dataEdit'),
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
                        GestureDetector(
                          onTap: _rasmTanlash,
                          child: Stack(
                            children: [
                              Container(
                                width: 120.w,
                                height: 120.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: rasm != null
                                      ? Image.file(rasm!, fit: BoxFit.cover)
                                      : networkImageUrl != null
                                      ? Image.network(
                                    networkImageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                      : Icon(
                                    Icons.person,
                                    size: 50.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.black
                                          : AppColors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                        CustomTextFeldWidget(
                          controller: phoneNumberController,
                          hintText: "Telefon raqamingiz",
                        ),
                        SizedBox(height: 16.h),
                        CustomDropDownWidget(
                          value: tanlanganViloyat,
                          hintText: "Viloyatingiz",
                          items: viloyatlar.entries
                              .map(
                                (entry) =>
                                DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(entry.value),
                                ),
                          )
                              .toList(),
                          onChanged: (yangi) =>
                              setState(() => tanlanganViloyat = yangi),
                        ),
                        SizedBox(height: 60.h),
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: profileState.status == Status.loading
                                ? null
                                : () => _saveProfile(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: profileState.status == Status.loading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : Text(
                              context.translate('save'),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

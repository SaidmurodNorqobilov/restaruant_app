import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../core/routing/routes.dart';
import '../../../auth/presentation/bloc/profileCubit/profile_cubit.dart';
import '../../../auth/presentation/bloc/profileCubit/profile_state.dart';
import '../../../auth/presentation/widgets/custom_text_field_widget.dart';
import '../bloc/userBloc/user_profile_bloc.dart';
import '../bloc/userBloc/user_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ismController = TextEditingController();
  final familiyaController = TextEditingController();

  // String? tanlanganViloyat;
  File? rasm;
  String? networkImageUrl;
  final phoneNumberController = TextEditingController();
  bool _isInitialized = false;

  // final viloyatlar = {
  //   "andijon": "Andijon",
  //   "buxoro": "Buxoro",
  //   "fargona": "Farg'ona",
  //   "jizzax": "Jizzax",
  //   "xorazm": "Xorazm",
  //   "namangan": "Namangan",
  //   "navoiy": "Navoiy",
  //   "qashqadaryo": "Qashqadaryo",
  //   "qoraqalpogiston": "Qoraqalpog'iston Respublikasiiii",
  //   "samarqand": "Samarqand",
  //   "sirdaryo": "Sirdaryo",
  //   "surxondaryo": "Surxondaryo",
  //   "toshkent_viloyati": "Toshkent viloyati",
  //   "toshkent_shahri": "Toshkent shahri",
  // };

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
    if (ismController.text.trim().isEmpty) {
      _showError('Ismingizni kiriting');
      return false;
    }
    if (familiyaController.text.trim().isEmpty) {
      _showError('Familyangizni kiriting');
      return false;
    }
    // if (tanlanganViloyat == null) {
    //   _showError('Viloyatingizni tanlang');
    //   return false;
    // }
    return true;
  }

  // void _showError(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.red,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //   );
  // }

  void _showError(String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(10.r),
      ),
      displayDuration: const Duration(seconds: 2),
    );
  }

  void _saveProfile(BuildContext context) {
    if (!_validateForm()) return;
    context.read<UserProfileBloc>().add(
      UpdateUserProfile(
        firstName: ismController.text.trim(),
        lastName: familiyaController.text.trim(),
        phone: phoneNumberController.text.trim(),
        // address: tanlanganViloyat ?? '',
        imageFile: rasm,
      ),
    );

    _showSuccessDialog(context);
    Navigator.pop(context);
  }

  // void _saveProfile(BuildContext context) {
  //   if (!_validateForm()) return;
  //   context.read<UserProfileBloc>().add(
  //     UpdateUserProfile(
  //       firstName: ismController.text.trim(),
  //       lastName: familiyaController.text.trim(),
  //       phone: phoneNumberController.text.trim(),
  //       imageFile: rasm,
  //     ),
  //   );
  // }

  void _showSuccessDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: isDark ? AppColors.black : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(isDark ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Muvaffaqiyatli!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Profilingiz muvaffaqiyatli yangilandi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.white.withOpacity(0.7)
                        : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.go(Routes.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
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
      body: Builder(
        builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: BlocConsumer<ProfileCubit, ProfileState>(
                  listener: (context, profileState) {
                    if (profileState.status == Status.success) {
                      context.read<UserProfileBloc>().add(GetUserProfile());
                    } else if (profileState.status == Status.error) {
                      _showError('Xatolik yuz berdi');
                    }
                  },
                  builder: (context, profileState) {
                    return BlocBuilder<UserProfileBloc, UserProfileState>(
                      builder: (context, userState) {
                        if (!_isInitialized && userState.user != null) {
                          _isInitialized = true;
                          ismController.text = userState.user!.firstName ?? "";
                          familiyaController.text =
                              userState.user!.lastName ?? "";
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
                                    color: AppColors.primary.withAlpha(21),
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
                                  'Profile Ma\'lumotlar yuklanmoqda...',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppColors.white.withAlpha(179)
                                        : AppColors.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (userState.status == Status.error) {
                          return Center(
                            child: Text("xatolik yuz berdi"),
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
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.black,
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
                                    ? AppColors.white.withAlpha(179)
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
                            // CustomDropDownWidget(
                            //   value: tanlanganViloyat,
                            //   hintText: "Viloyatingiz",
                            //   items: viloyatlar.entries
                            //       .map(
                            //         (entry) =>
                            //         DropdownMenuItem(
                            //           value: entry.key,
                            //           child: Text(entry.value),
                            //         ),
                            //   )
                            //       .toList(),
                            //   onChanged: (yangi) =>
                            //       setState(() => tanlanganViloyat = yangi),
                            // ),
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
          );
        },
      ),
    );
  }
}

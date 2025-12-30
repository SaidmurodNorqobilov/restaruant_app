import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/user_service.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/icons.dart';
import '../widgets/profile_item_widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? rasm;
  String fullName = '';
  String phone = '';
  String region = '';
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    UserService.userDataChanged.addListener(_loadUserData);
    _loadUserData();
  }

  @override
  void dispose() {
    UserService.userDataChanged.removeListener(_loadUserData);
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final isUserLoggedIn = await UserService.isLoggedIn();
      final userData = await UserService.getUserData();

      if (mounted) {
        setState(() {
          isLoggedIn = isUserLoggedIn;
          fullName = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();
          phone = userData['phone'] ?? '';
          region = userData['region'] ?? '';

          if (userData['imagePath'] != null && userData['imagePath']!.isNotEmpty) {
            rasm = File(userData['imagePath']!);
          } else {
            rasm = null;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _rasmTanlash() async {
    final picker = ImagePicker();
    final tanlangan = await picker.pickImage(source: ImageSource.gallery);
    if (tanlangan != null) {
      await UserService.updateProfileImage(tanlangan.path);
    }
  }

  void _rasmniKattalashtirish() {
    if (rasm == null) return;
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20.w),
          child: Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 40.w,
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        rasm!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40.h,
                right: 20.w,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    await UserService.logout();
    if (mounted) {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (!isLoggedIn) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 60.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Ma\'lumot kiritilmagan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Profilingizni to\'ldirish uchun tizimga kiring yoki ro\'yxatdan o\'ting',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.white.withOpacity(0.7)
                        : AppColors.black.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButtonApp(
                    onPressed: () {
                      context.push(Routes.login);
                    },
                    text: 'Kirish',
                    textColor: AppColors.white,
                    buttonColor: AppColors.primary,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      drawer: const DrawerWidgets(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(
              color: AppColors.white,
            ),
            expandedHeight: 220.h,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
            title: Text(
              context.translate('profile'),
              style: const TextStyle(
                color: AppColors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: isDark ? AppColors.darkAppBar : AppColors.primary,
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 100.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onLongPress: rasm != null ? _rasmniKattalashtirish : null,
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40.r,
                              backgroundImage: rasm != null ? FileImage(rasm!) : null,
                              child: rasm == null
                                  ? Icon(
                                Icons.person,
                                size: 40.sp,
                                color: Colors.grey,
                              )
                                  : null,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _rasmTanlash,
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit,
                                color: isDark ? AppColors.darkAppBar : AppColors.primary,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            fullName.isNotEmpty ? fullName : 'Foydalanuvchi',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          if (phone.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: 14.sp,
                                  color: AppColors.white.withOpacity(0.9),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  phone,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          if (region.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14.sp,
                                  color: AppColors.white.withOpacity(0.9),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  region,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileItemWidget(
                    onTap: () {
                      context.push(Routes.profileSign);
                    },
                    text: context.translate('editProfile'),
                    icon: AppIcons.profile,
                    iconBack: AppIcons.arrowRightGreen,
                  ),
                  SizedBox(height: 12.h),
                  ProfileItemWidget(
                    onTap: () {
                      context.push(Routes.order);
                    },
                    text: context.translate('orders'),
                    icon: AppIcons.orders,
                    iconBack: AppIcons.arrowRightGreen,
                  ),
                  SizedBox(height: 12.h),
                  ProfileItemWidget(
                    onTap: () {
                      context.push(Routes.refund);
                    },
                    text: context.translate('refund'),
                    icon: AppIcons.refund,
                    iconBack: AppIcons.arrowRightGreen,
                  ),
                  SizedBox(height: 12.h),
                  ProfileItemWidget(
                    onTap: () {
                      context.push(Routes.about);
                    },
                    text: context.translate('about'),
                    icon: AppIcons.infoSquare,
                    iconBack: AppIcons.arrowRightGreen,
                  ),
                  SizedBox(height: 12.h),
                  ProfileItemWidget(
                    onTap: () {},
                    text: context.translate('terms'),
                    icon: AppIcons.cart,
                  ),
                  SizedBox(height: 12.h),
                  ProfileItemWidget(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkAppBar : AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.r),
                              topRight: Radius.circular(25.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 30.h,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 50.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.logout_rounded,
                                    size: 40.sp,
                                    color: AppColors.red,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  context.translate('exits'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.white : AppColors.textColor,
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButtonApp(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        text: context.translate('no'),
                                        textColor: AppColors.textColor,
                                        buttonColor: AppColors.borderColor,
                                        height: 50,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: TextButtonApp(
                                        onPressed: () {
                                          context.pop();
                                          _logout();
                                        },
                                        text: context.translate('yes'),
                                        textColor: AppColors.white,
                                        buttonColor: AppColors.red,
                                        height: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    textColor: AppColors.red,
                    iconColorFilter: const ColorFilter.mode(
                      AppColors.red,
                      BlendMode.srcIn,
                    ),
                    text: 'Chiqish',
                    icon: AppIcons.logout,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
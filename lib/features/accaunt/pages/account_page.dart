import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/user_service.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/icons.dart';
import '../managers/user_profile_bloc.dart';
import '../managers/user_profile_state.dart';
import '../widgets/profile_item_widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(GetUserProfile());
  }

  Future<void> _rasmTanlash() async {
    final picker = ImagePicker();
    final tanlangan = await picker.pickImage(source: ImageSource.gallery);
    if (tanlangan != null) {
      await UserService.updateProfileImage(tanlangan.path);
      if (mounted) {
        context.read<UserProfileBloc>().add(GetUserProfile());
      }
    }
  }

  void _rasmniKattalashtirish(String? networkImage) {
    if (networkImage == null) return;
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
                      child: Image.network(
                        networkImage,
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
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
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
                  'Ma\'lumotlar yuklanmoqda...',
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

        if (state.user == null) {
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

        final user = state.user!;
        final fullName = '${user.firstName} ${user.lastName}'.trim();
        final phone = user.phone;

        return Scaffold(
          drawer: const DrawerWidgets(),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                iconTheme: const IconThemeData(
                  color: AppColors.white,
                ),
                expandedHeight: 240.h,
                pinned: true,
                backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
                title: Text(
                  context.translate('profile'),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [AppColors.darkAppBar, AppColors.darkAppBar]
                            : [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: 24.w,
                      right: 24.w,
                      top: 80.h,
                      bottom: 20.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onLongPress: user.image != null
                                  ? () => _rasmniKattalashtirish(user.image)
                                  : null,
                              child: Container(
                                width: 100.w,
                                height: 100.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 48.r,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: (user.image != null && user.image!.isNotEmpty)
                                      ? NetworkImage(user.image!)
                                      : null,
                                  child: (user.image == null || user.image!.isEmpty)
                                      ? Icon(
                                    Icons.person,
                                    size: 48.sp,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _rasmTanlash,
                                child: Container(
                                  width: 36.w,
                                  height: 36.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: AppColors.primary,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          fullName.isNotEmpty ? fullName : 'Foydalanuvchi',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        if (phone.isNotEmpty) ...[
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 16.sp,
                                color: AppColors.white.withOpacity(0.9),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                phone,
                                style: TextStyle(
                                  fontSize: 15.sp,
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
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMenuItem(
                        context: context,
                        icon: Icons.edit_outlined,
                        title: context.translate('editProfile'),
                        subtitle: 'Shaxsiy ma\'lumotlarni tahrirlash',
                        onTap: () => context.push(Routes.editProfile),
                        isDark: isDark,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.receipt_long_outlined,
                        title: context.translate('orders'),
                        subtitle: 'Buyurtmalar tarixi',
                        onTap: () => context.push(Routes.order),
                        isDark: isDark,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.money_off_outlined,
                        title: context.translate('refund'),
                        subtitle: 'Qaytarilgan to\'lovlar',
                        onTap: () => context.push(Routes.refund),
                        isDark: isDark,
                        color: Colors.green,
                      ),
                      SizedBox(height: 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.info_outline,
                        title: context.translate('about'),
                        subtitle: 'Ilova haqida ma\'lumot',
                        onTap: () => context.push(Routes.about),
                        isDark: isDark,
                        color: Colors.purple,
                      ),
                      SizedBox(height: 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.description_outlined,
                        title: context.translate('terms'),
                        subtitle: 'Foydalanish shartlari',
                        onTap: () {},
                        isDark: isDark,
                        color: Colors.teal,
                      ),
                      SizedBox(height: 20.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.logout_rounded,
                        title: 'Chiqish',
                        subtitle: 'Akkauntdan chiqish',
                        onTap: () => _showLogoutDialog(context, isDark),
                        isDark: isDark,
                        color: AppColors.red,
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    required Color color,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? AppColors.borderColor.withOpacity(0.1)
                : AppColors.borderColor.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? AppColors.red
                          : (isDark ? AppColors.white : AppColors.textColor),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.sp,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: 12.h),
              Text(
                'Rostdan ham akkauntdan chiqmoqchimisiz?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: TextButtonApp(
                      onPressed: () => context.pop(),
                      text: context.translate('no'),
                      textColor: isDark ? AppColors.white : AppColors.textColor,
                      buttonColor: isDark
                          ? AppColors.borderColor.withOpacity(0.2)
                          : AppColors.borderColor,
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
  }
}
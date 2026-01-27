import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/accaunt/widgets/custom_menu_item_widget.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/network/user_service.dart';
import '../../../core/utils/colors.dart';
import '../../auth/managers/authCubit/auth_cubit.dart';
import '../../auth/managers/authCubit/auth_state.dart';
import '../../common/widgets/common_state_widgets.dart';
import '../managers/userBloc/user_profile_bloc.dart';
import '../managers/userBloc/user_profile_state.dart';
import '../widgets/logout_dialog_widget.dart';
import '../widgets/qr_cashback_dialog_widget.dart';

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

  // Future<void> _logout() async {
  //   await UserService.logout();
  //   if (mounted) {
  //     context.go(
  //       Routes.login,
  //     );
  //   }
  // }
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Chiqish"),
        content: Text(
          "Haqiqatan ham tizimdan chiqmoqchimisiz?",
          style: TextStyle(
            color: AppColors.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Bekor qilish", style: TextStyle(color: AppColors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Chiqish", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<AuthCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    // final bool isDesktop = screenWidth >= 1024;

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return LoadingState(
            isDark: isDark,
            isTablet: isTablet,
          );
        }
        if (state.user == null) {
          return UserNullWidget();
        }
        final user = state.user!;
        final fullName = '${user.firstName} ${user.lastName}'.trim();
        final phone = user.phone;

        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (!state.isAuthenticated) {
              context.go(Routes.login);
            }
          },
          child: Scaffold(
            drawer: const DrawerWidgets(),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  iconTheme: const IconThemeData(
                    color: AppColors.white,
                  ),
                  expandedHeight: isTablet ? 280.h : 240.h,
                  pinned: true,
                  backgroundColor: isDark
                      ? AppColors.darkAppBar
                      : AppColors.primary,
                  title: Text(
                    context.translate('profile'),
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 20.sp : 18.sp,
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
                              : [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.8),
                                ],
                        ),
                      ),
                      padding: EdgeInsets.only(
                        left: isTablet ? 32.w : 24.w,
                        right: isTablet ? 32.w : 24.w,
                        top: isTablet ? 100.h : 80.h,
                        bottom: isTablet ? 28.h : 20.h,
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
                                  width: isTablet ? 60.w : 100.w,
                                  height: isTablet ? 60.w : 100.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: isTablet ? 5 : 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(51),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: isTablet ? 58.r : 48.r,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage:
                                        (user.image != null &&
                                            user.image!.isNotEmpty)
                                        ? NetworkImage(user.image!)
                                        : null,
                                    child:
                                        (user.image == null ||
                                            user.image!.isEmpty)
                                        ? Icon(
                                            Icons.person,
                                            size: isTablet ? 38.sp : 48.sp,
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
                                    width: isTablet ? 20.w : 36.w,
                                    height: isTablet ? 20.w : 36.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(51),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: AppColors.primary,
                                      size: isTablet ? 12.sp : 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 8.h : 6.h),
                          Text(
                            fullName.isNotEmpty ? fullName : 'Foydalanuvchi',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isTablet ? 12.sp : 22.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          if (phone.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: isTablet ? 12.sp : 16.sp,
                                  color: AppColors.white.withAlpha(230),
                                ),
                                SizedBox(width: isTablet ? 8.w : 6.w),
                                Text(
                                  phone,
                                  style: TextStyle(
                                    fontSize: isTablet ? 9.sp : 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white.withAlpha(230),
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
                      horizontal: isTablet ? 24.w : 16.w,
                      vertical: isTablet ? 28.h : 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomMenuItem(
                          icon: Icons.edit_outlined,
                          title: context.translate('editProfile'),
                          subtitle: context.translate('personEdit'),
                          onTap: () => context.push(Routes.editProfile),
                          isDark: isDark,
                          color: Colors.blue,
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        CustomMenuItem(
                          icon: Icons.receipt_long_outlined,
                          title: context.translate('orders'),
                          subtitle: context.translate('orderHistory'),
                          onTap: () => context.push(Routes.order),
                          isDark: isDark,
                          color: Colors.orange,
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        CustomMenuItem(
                          icon: Icons.location_on,
                          title: context.translate('location'),
                          subtitle: context.translate('inputLocation'),
                          onTap: () => context.push(Routes.location),
                          isDark: isDark,
                          color: Colors.lightBlue,
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        CustomMenuItem(
                          icon: Icons.money_off_outlined,
                          title: context.translate('refund'),
                          subtitle: context.translate('cancelRefund'),
                          onTap: () => context.push(Routes.refund),
                          isDark: isDark,
                          color: Colors.green,
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        CustomMenuItem(
                          icon: Icons.info_outline,
                          title: context.translate('about'),
                          subtitle: context.translate('appAbout'),
                          onTap: () => context.push(Routes.about),
                          isDark: isDark,
                          color: Colors.purple,
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        CustomMenuItem(
                          icon: Icons.description_outlined,
                          title: context.translate('terms'),
                          subtitle: context.translate('terms'),
                          onTap: () {},
                          isDark: isDark,
                          color: Colors.teal,
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        CustomMenuItem(
                          icon: Icons.qr_code_2,
                          title: "QR Cashback",
                          subtitle: context.translate('qrCashback'),
                          onTap: () => QRCashbackDialog.show(
                            context: context,
                            isDark: isDark,
                            isTablet: isTablet,
                            user: user,
                          ),
                          isDark: isDark,
                          color: AppColors.orange,
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 28.h : 20.h),
                        CustomMenuItem(
                          icon: Icons.logout_rounded,
                          title: 'Chiqish',
                          subtitle: context.translate('exitAccount'),
                          onTap: () => LogoutDialog.show(
                            context: context,
                            isDark: isDark,
                            isTablet: isTablet,
                            onLogout: _logout,
                          ),
                          isDark: isDark,
                          color: AppColors.red,
                          isDestructive: true,
                          isTablet: isTablet,
                        ),
                      ],
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
}

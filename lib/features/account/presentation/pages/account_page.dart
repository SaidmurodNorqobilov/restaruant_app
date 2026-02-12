import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/network/localization_extension.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common_state_widgets.dart';
import '../../../../core/widgets/drawer_widgets.dart';
import '../../../auth/data/datasources/user_service.dart';
import '../../../auth/presentation/bloc/authCubit/auth_cubit.dart';
import '../../../auth/presentation/bloc/authCubit/auth_state.dart';
import '../bloc/userBloc/user_profile_bloc.dart';
import '../bloc/userBloc/user_profile_state.dart';
import '../widgets/custom_menu_item_widget.dart';
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
        title: const Text(
          "Chiqish",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        content: Text(
          "Haqiqatan ham tizimdan chiqmoqchimisiz?",
          style: TextStyle(
            color: AppColors.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Bekor qilish",
              style: TextStyle(
                color: AppColors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Chiqish",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
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
                  iconTheme: const IconThemeData(color: AppColors.white),
                  expandedHeight: isTablet ? 400.h : 300.h,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    context.translate('profile'),
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 20.sp : 18.sp,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      AppColors.darkAppBar,
                                      AppColors.darkAppBar.withAlpha(200),
                                      Colors.purple.shade900.withAlpha(100),
                                    ]
                                  : [
                                      AppColors.primary,
                                      AppColors.primary.withAlpha(220),
                                      Colors.blue.shade700,
                                    ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withAlpha(13),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withAlpha(10),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: isTablet ? 32.w : 24.w,
                              right: isTablet ? 32.w : 24.w,
                              top: isTablet ? 100.h : 80.h,
                              bottom: isTablet ? 28.h : 24.h,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withAlpha(128),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onLongPress: user.image != null
                                        ? () =>
                                              _rasmniKattalashtirish(user.image)
                                        : null,
                                    child: Container(
                                      width: isTablet ? 70.w : 110.w,
                                      height: isTablet ? 70.w : 110.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.white,
                                          width: 5,
                                        ),
                                        gradient:
                                            user.image == null ||
                                                user.image!.isEmpty
                                            ? LinearGradient(
                                                colors: [
                                                  Colors.blue.shade400,
                                                  Colors.purple.shade400,
                                                ],
                                              )
                                            : null,
                                      ),
                                      child: CircleAvatar(
                                        radius: isTablet ? 53.r : 53.r,
                                        backgroundColor: Colors.transparent,
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
                                                size: 50.sp,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 16.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withAlpha(26),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.white.withAlpha(51),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            fullName.isNotEmpty
                                                ? fullName
                                                : 'Foydalanuvchi',
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: isTablet
                                                  ? 14.sp
                                                  : 20.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          if (phone.isNotEmpty) ...[
                                            SizedBox(height: 12.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                          8,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: AppColors
                                                                  .white
                                                                  .withAlpha(
                                                                    26,
                                                                  ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                        child: Icon(
                                                          Icons.phone_outlined,
                                                          size: 16.sp,
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Flexible(
                                                        child: Text(
                                                          "+${phone}",
                                                          style: TextStyle(
                                                            fontSize: isTablet
                                                                ? 12.sp
                                                                : 14.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .white
                                                                .withAlpha(230),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 30.h,
                                                  width: 1,
                                                  color: AppColors.white
                                                      .withAlpha(51),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                          5,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Colors
                                                                      .amber
                                                                      .shade400,
                                                                  Colors
                                                                      .orange
                                                                      .shade400,
                                                                ],
                                                              ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.monetization_on,
                                                          size: isTablet
                                                              ? 14.sp
                                                              : 20.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Text(
                                                        "${user.coinBalance}",
                                                        style: TextStyle(
                                                          fontSize: isTablet
                                                              ? 12.sp
                                                              : 16.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors
                                                              .amber
                                                              .shade300,
                                                        ),
                                                      ),
                                                    ],
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
                              ],
                            ),
                          ),
                        ),
                      ],
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
                        SizedBox(
                          height: isTablet ? 16.h : 12.h,
                        ),
                        CustomMenuItem(
                          icon: Icons.receipt_long_outlined,
                          title: context.translate('orders'),
                          subtitle: context.translate('orderHistory'),
                          onTap: () => context.push(Routes.orders),
                          isDark: isDark,
                          color: Colors.orange,
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        CustomMenuItem(
                          icon: Icons.location_on,
                          title: context.translate('location'),
                          subtitle: context.translate('inputLocation'),
                          onTap: () => context.push(Routes.myLocations),
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
                        SizedBox(
                          height: isTablet ? 16.h : 12.h,
                        ),
                        CustomMenuItem(
                          icon: Icons.description_outlined,
                          title: context.translate('terms'),
                          subtitle: context.translate('terms'),
                          onTap: () {},
                          isDark: isDark,
                          color: Colors.teal,
                          isTablet: isTablet,
                        ),
                        SizedBox(
                          height: isTablet ? 16.h : 12.h,
                        ),
                        CustomMenuItem(
                          icon: Icons.qr_code_2,
                          title: "Mening tanglarim",
                          // subtitle: context.translate('qrCashback'),
                          subtitle: 'Coinlarni ko\'rish',
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

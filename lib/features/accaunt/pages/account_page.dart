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
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/onboarding/widgets/text_button_app.dart';
import '../../../core/network/user_service.dart';
import '../../../core/utils/colors.dart';
import '../../common/widgets/common_state_widgets.dart';
import '../managers/userBloc/user_profile_bloc.dart';
import '../managers/userBloc/user_profile_state.dart';

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
      context.go(
        Routes.login,
      );
    }
  }

  void _showQRCashbackDialog(
    BuildContext context,
    bool isDark,
    bool isTablet,
    dynamic user,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(128),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.65,
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32.w : 24.w,
            vertical: isTablet ? 28.h : 20.h,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkAppBar : AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: isTablet ? 25.h : 20.h),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withAlpha(179),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Mening QR Kodim',
                    style: TextStyle(
                      fontSize: isTablet ? 28.sp : 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 14.h : 10.h),
                Text(
                  'Kassirga ushbu QR kodni ko\'rsating',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 16.sp : 14.sp,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: isTablet ? 38.h : 30.h),
                Container(
                  padding: EdgeInsets.all(isTablet ? 28.w : 24.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(51),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 22.w : 18.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: QrImageView(
                          data: 'USER_${user.id ?? 'unknown'}',
                          version: QrVersions.auto,
                          size: isTablet ? 240 : 250,
                          backgroundColor: AppColors.white,
                          eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: AppColors.primary,
                          ),
                          dataModuleStyle: QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 28.h : 22.h),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: isTablet ? 24.w : 20.w,
                      //     vertical: isTablet ? 16.h : 12.h,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: isDark
                      //         ? AppColors.primary.withOpacity(0.15)
                      //         : AppColors.primary.withAlpha(21)
                      //     borderRadius: BorderRadius.circular(12.r),
                      //     border: Border.all(
                      //       color: AppColors.primary.withAlpha(77)
                      //       width: 1.5,
                      //     ),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         'Sizning ID raqamingiz',
                      //         style: TextStyle(
                      //           fontSize: isTablet ? 15.sp : 13.sp,
                      //           color: isDark ? Colors.white70 : Colors.grey[700],
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.h),
                      //       Text(
                      //         'USER${user.id ?? 'N/A'}',
                      //         style: TextStyle(
                      //           fontSize: isTablet ? 26.sp : 22.sp,
                      //           fontWeight: FontWeight.w700,
                      //           color: AppColors.primary,
                      //           letterSpacing: 2,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 28.h : 22.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 28.w : 24.w,
                    vertical: isTablet ? 18.h : 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(21),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            color: AppColors.primary,
                            size: isTablet ? 26.sp : 22.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Mening balansim',
                            style: TextStyle(
                              fontSize: isTablet ? 16.sp : 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '0 coins',
                        style: TextStyle(
                          fontSize: isTablet ? 32.sp : 28.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 28.h : 22.h),
                Text(
                  'Kassada to\'lov qilgandan keyin\nbu QR kodni ko\'rsating',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 17.sp : 15.sp,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isTablet ? 32.h : 26.h),
                Container(
                  padding: EdgeInsets.all(isTablet ? 18.w : 14.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.green.withOpacity(0.15)
                        : Colors.green.withAlpha(21),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.green.withAlpha(77),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.green,
                        size: isTablet ? 26.sp : 22.sp,
                      ),
                      SizedBox(width: isTablet ? 14.w : 12.w),
                      Expanded(
                        child: Text(
                          'Har bir xarid uchun 5% cashback coinlar sifatida hisobingizga tushadi',
                          style: TextStyle(
                            fontSize: isTablet ? 15.sp : 13.sp,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 32.h : 26.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Yopish',
                    style: TextStyle(
                      fontSize: isTablet ? 17.sp : 15.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          // return Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         width: isTablet ? 100.w : 80.w,
          //         height: isTablet ? 100.w : 80.w,
          //         decoration: BoxDecoration(
          //           color: AppColors.primary.withAlpha(21),
          //           shape: BoxShape.circle,
          //         ),
          //         child: Stack(
          //           alignment: Alignment.center,
          //           children: [
          //             SizedBox(
          //               width: isTablet ? 75.w : 60.w,
          //               height: isTablet ? 75.w : 60.w,
          //               child: CircularProgressIndicator(
          //                 strokeWidth: isTablet ? 4 : 3,
          //                 valueColor: AlwaysStoppedAnimation<Color>(
          //                   AppColors.primary,
          //                 ),
          //               ),
          //             ),
          //             Icon(
          //               Icons.restaurant_menu,
          //               size: isTablet ? 35.sp : 28.sp,
          //               color: AppColors.primary,
          //             ),
          //           ],
          //         ),
          //       ),
          //       SizedBox(height: isTablet ? 30.h : 24.h),
          //       Text(
          //         'Ma\'lumotlar yuklanmoqda...',
          //         style: TextStyle(
          //           fontSize: isTablet ? 18.sp : 16.sp,
          //           fontWeight: FontWeight.w500,
          //           color: isDark
          //               ? AppColors.white.withAlpha(179)
          //               : AppColors.black.withOpacity(0.6),
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        }

        if (state.user == null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32.w : 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: isTablet ? 140.w : 120.w,
                      height: isTablet ? 140.h : 120.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(21),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: isTablet ? 70.sp : 60.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: isTablet ? 38.h : 30.h),
                    Text(
                      'Ma\'lumot kiritilmagan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 28.sp : 24.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16.h : 12.h),
                    Text(
                      'Profilingizni to\'ldirish uchun tizimga kiring yoki ro\'yxatdan o\'ting',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 16.sp : 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.white.withAlpha(179)
                            : AppColors.black.withOpacity(0.6),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: isTablet ? 48.h : 40.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButtonApp(
                        onPressed: () {
                          context.push(Routes.login);
                        },
                        text: 'Kirish',
                        textColor: AppColors.white,
                        buttonColor: AppColors.primary,
                        height: isTablet ? 58 : 50,
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
                      _buildMenuItem(
                        context: context,
                        icon: Icons.edit_outlined,
                        title: context.translate('editProfile'),
                        subtitle: context.translate('personEdit'),
                        onTap: () => context.push(Routes.editProfile),
                        isDark: isDark,
                        color: Colors.blue,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16.h : 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.receipt_long_outlined,
                        title: context.translate('orders'),
                        subtitle: context.translate('orderHistory'),
                        onTap: () => context.push(Routes.order),
                        isDark: isDark,
                        color: Colors.orange,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16.h : 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.location_on,
                        title: context.translate('location'),
                        subtitle: context.translate('inputLocation'),
                        onTap: () => context.push(Routes.location),
                        isDark: isDark,
                        color: Colors.lightBlue,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16.h : 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.money_off_outlined,
                        title: context.translate('refund'),
                        subtitle: context.translate('cancelRefund'),
                        onTap: () => context.push(Routes.refund),
                        isDark: isDark,
                        color: Colors.green,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16.h : 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.info_outline,
                        title: context.translate('about'),
                        subtitle: context.translate('appAbout'),
                        onTap: () => context.push(Routes.about),
                        isDark: isDark,
                        color: Colors.purple,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16.h : 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.description_outlined,
                        title: context.translate('terms'),
                        subtitle: context.translate('terms'),
                        onTap: () {},
                        isDark: isDark,
                        color: Colors.teal,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16.h : 12.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.qr_code_2,
                        title: "QR Cashback",
                        subtitle: context.translate('qrCashback'),
                        onTap: () => _showQRCashbackDialog(
                          context,
                          isDark,
                          isTablet,
                          user,
                        ),
                        isDark: isDark,
                        color: AppColors.orange,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: isTablet ? 28.h : 20.h),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.logout_rounded,
                        title: 'Chiqish',
                        subtitle: context.translate('exitAccount'),
                        onTap: () =>
                            _showLogoutDialog(context, isDark, isTablet),
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
    required bool isTablet,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 10.w : 16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? AppColors.borderColor.withAlpha(21)
                : AppColors.borderColor.withAlpha(51),
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
              width: isTablet ? 26.w : 48.w,
              height: isTablet ? 26.w : 48.w,
              decoration: BoxDecoration(
                color: color.withAlpha(21),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: isTablet ? 18.sp : 24.sp,
              ),
            ),
            SizedBox(width: isTablet ? 20.w : 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 14.sp : 16.sp,
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
                      fontSize: isTablet ? 12.sp : 13.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: isTablet ? 15.sp : 18.sp,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDark, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(128),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 32.w : 24.w,
              vertical: isTablet ? 28.h : 20.h,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: isTablet ? 35.h : 30.h),
                Container(
                  width: isTablet ? 95.w : 80.w,
                  height: isTablet ? 95.h : 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(51),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: isTablet ? 60.sp : 50.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: isTablet ? 35.h : 30.h),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withAlpha(179),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    context.translate('exits'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 28.sp : 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 50.h : 45.h),
                Container(
                  width: double.infinity,
                  height: isTablet ? 62.h : 55.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(77),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: AppColors.white,
                              size: isTablet ? 26.sp : 22.sp,
                            ),
                            SizedBox(width: isTablet ? 12.w : 10.w),
                            Text(
                              context.translate('exit'),
                              style: TextStyle(
                                fontSize: isTablet ? 18.sp : 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 16.h : 14.h),
                Container(
                  width: double.infinity,
                  height: isTablet ? 62.h : 55.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: AppColors.primary.withAlpha(77),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          context.translate('cancel'),
                          style: TextStyle(
                            fontSize: isTablet ? 18.sp : 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

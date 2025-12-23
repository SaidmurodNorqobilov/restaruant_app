import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
import 'package:restaurantapp/features/menu/widgets/app_bar_home.dart';
import 'package:restaurantapp/main.dart';
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

  Future<void> _rasmTanlash() async {
    final picker = ImagePicker();
    final tanlangan = await picker.pickImage(source: ImageSource.gallery);
    if (tanlangan != null) {
      setState(() {
        rasm = File(tanlangan.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarHome(
        title: Text(
          localization.translate('profile'),
        ),
      ),
      drawer: DrawerWidgets(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              SizedBox(height: 24.h),
              Column(
                children: [
                  Align(
                    alignment: AlignmentGeometry.center,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.r,
                          child: Icon(
                            Icons.person,
                            size: 60.sp,
                            color: Colors.grey,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _rasmTanlash,
                            child: CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Profile Name",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color:
                          Theme.of(context).appBarTheme.foregroundColor ??
                          AppColors.darkAppBar,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "+998970001001",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          Theme.of(context).appBarTheme.foregroundColor ??
                          AppColors.darkAppBar,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),
              Divider(color: AppColors.darkAppBar, height: 32.h),
              Column(
                spacing: 12.h,
                children: [
                  ProfileItemWidget(
                    onTap: () {},
                    text: localization.translate('editProfile'),
                    icon: AppIcons.profile,
                    iconBack: AppIcons.arrowRightGreen,
                  ),
                  ProfileItemWidget(
                    onTap: () {},
                    text: localization.translate('payments'),
                    icon: AppIcons.wallet,
                    iconBack: AppIcons.arrowRightGreen,
                  ),
                  ProfileItemWidget(
                    onTap: () {
                      context.push(Routes.order);
                    },
                    text: localization.translate('orders'),
                    icon: AppIcons.shieldDone,
                    iconBack: AppIcons.arrowRightGreen,
                  ),
                  SizedBox(
                    height: 40.h,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: () {
                        context.push(Routes.refund);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.currency_exchange,
                                weight: 24,
                                color:
                                    Theme.of(
                                      context,
                                    ).appBarTheme.foregroundColor ??
                                    Colors.black,
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                localization.translate('refund'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: Theme.of(
                                    context,
                                  ).appBarTheme.foregroundColor,
                                ),
                              ),
                            ],
                          ),
                          SvgPicture.asset(
                            AppIcons.arrowRightGreen,
                            width: 20.w,
                            height: 20.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ProfileItemWidget(
                    onTap: () {
                      context.push(Routes.about);
                    },
                    text: localization.translate('about'),
                    icon: AppIcons.infoSquare,
                    iconBack: AppIcons.arrowRightGreen,
                  ),
                  ProfileItemWidget(
                    onTap: () {},
                    text: localization.translate('terms'),
                    icon: AppIcons.send,
                  ),
                  ProfileItemWidget(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: isDark
                            ? AppColors.darkAppBar
                            : AppColors.white,
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 35.h,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 290.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  localization.translate('exit'),
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.red,
                                  ),
                                ),
                                Text(
                                  localization.translate('exits'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkAppBar,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    textColor: AppColors.red,
                    iconColorFilter: ColorFilter.mode(
                      AppColors.red,
                      BlendMode.srcIn,
                    ),
                    text: 'Chiqish',
                    icon: AppIcons.logout,
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/localization_extension.dart';
import 'package:restaurantapp/features/common/widgets/drawer_widgets.dart';
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
                    decoration: BoxDecoration(
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: DrawerWidgets(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(
              color: AppColors.white,
            ),
            expandedHeight: 200.h,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
            title: Text(
              context.translate('profile'),
              style: TextStyle(
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
                  spacing: 25.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onLongPress: _rasmniKattalashtirish,
                          child: CircleAvatar(
                            radius: 40.r,
                            backgroundImage: rasm != null
                                ? FileImage(rasm!)
                                : null,
                            child: rasm == null
                                ? Icon(
                                    Icons.person,
                                    size: 40.sp,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _rasmTanlash,
                            child: CircleAvatar(
                              radius: 16.r,
                              backgroundColor: AppColors.white,
                              child: Icon(
                                Icons.edit,
                                color: isDark
                                    ? AppColors.darkAppBar
                                    : AppColors.primary,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 7.h,
                        children: [
                          Text(
                            "Saidmurod Norqobilov",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            "+998914527455",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
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
                vertical: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Column(
                    spacing: 12.h,
                    children: [
                      ProfileItemWidget(
                        onTap: () {},
                        text: context.translate('editProfile'),
                        icon: AppIcons.profile,
                        iconBack: AppIcons.arrowRightGreen,
                      ),
                      ProfileItemWidget(
                        onTap: () {
                          context.push(Routes.order);
                        },
                        text: context.translate('orders'),
                        icon: AppIcons.orders,
                        iconBack: AppIcons.arrowRightGreen,
                      ),
                      ProfileItemWidget(
                        onTap: () {
                          context.push(Routes.refund);
                        },
                        text: context.translate('refund'),
                        icon: AppIcons.refund,
                        iconBack: AppIcons.arrowRightGreen,
                      ),
                      ProfileItemWidget(
                        onTap: () {
                          context.push(Routes.about);
                        },
                        text: context.translate('about'),
                        icon: AppIcons.infoSquare,
                        iconBack: AppIcons.arrowRightGreen,
                      ),
                      ProfileItemWidget(
                        onTap: () {},
                        text: context.translate('terms'),
                        icon: AppIcons.cart,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.translate('exit'),
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.red,
                                      ),
                                    ),
                                    Text(
                                      context.translate('exits'),
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
        ],
      ),
    );
  }
}

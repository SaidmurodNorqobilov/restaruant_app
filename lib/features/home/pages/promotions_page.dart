import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';

class PromotionsPage extends StatefulWidget {
  final int id;

  const PromotionsPage({super.key, required this.id});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  final List<String> promotionsImg = [
    'https://i.pinimg.com/originals/66/9a/74/669a747cfd6d747b91559b93f882e213.jpg',
    'https://img.wattpad.com/3b0e3d5c09d515350894f151bba1fa4edde27376/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f776174747061642d6d656469612d736572766963652f53746f7279496d6167652f357a6f78594861553575374562673d3d2d313136303832383238342e313663333466383931643838393266383834363438303538383332392e6a7067?s=fit&w=720&h=720',
    'https://img.wallscloud.net/uploads/thumb/137910883/cocktails-1-63026-1024x576-MM-80.webp',
  ];
  final List<String> promotionsTitle = [
    'Milk shakes',
    'Artisan Lattes',
    'test',
  ];
  final List<double> promotionsPrice = [85.00, 35.00, 45.00];
  final List<double> promotionsAc = [95.00, 65.00, 65.00];
  final List<int> promotionsDiscount = [5, 7, 9];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const AppBarWidgets(title: 'Promotions'),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: List.generate(promotionsImg.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: GestureDetector(
                  onTap: () => context.push(Routes.recipeDetails, extra: index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkAppBar : AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      children: [
                        Image.network(
                          Routes.about,
                          width: 130.w,
                          height: 105.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 130.w,
                                height: 105.h,
                                color: Colors.grey,
                              ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  promotionsTitle[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.textColor,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Text(
                                      "AED ${promotionsAc[index]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.sp,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        "AED ${promotionsPrice[index]}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "${promotionsDiscount[index]}% Discount",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: AppColors.green,
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
              );
            }),
          ),
        ),
      ),
    );
  }
}

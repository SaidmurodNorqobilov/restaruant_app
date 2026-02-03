import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';

import '../../../../core/widgets/appbar_widgets.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List orderProducts = [
    'https://static.toiimg.com/photo/102941656.cms',
    'https://townsquare.media/site/385/files/2023/06/attachment-milkshake-.jpg?w=1200&q=75&format=natural',
    'https://i.pinimg.com/originals/32/07/8e/32078e4d3c1e9edb4d76dba9a419f71f.jpg',
  ];
  List orderTitle = [
    'Provencal Breakf',
    '2 Provencal Breakf',
    '4 Provesfsdfncal Bredghdfgsdfgsgfdakf',
  ];

  String status = 'Pending';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: 'nimadur'),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 24.w),
          child: Column(
            spacing: 30.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20.h,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.borderColor,
                            ),
                          ),
                          Text(
                            'Backend Time',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Number:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.borderColor,
                            ),
                          ),
                          Text(
                            'Backend Number',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order by : ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.borderColor,
                            ),
                          ),
                          Text(
                            'Backend Name',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client Phone: ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.borderColor,
                            ),
                          ),
                          Text(
                            'Backend data',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery type:',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.borderColor,
                        ),
                      ),
                      Text(
                        'Backend Name',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.white : AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location:',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.borderColor,
                        ),
                      ),
                      Text(
                        'Backend Name',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.white : AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.borderColor,
                        ),
                      ),
                      Text(
                        '\$ Price',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Column(
                spacing: 20.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items ( item Backend )',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.borderColor,
                    ),
                  ),
                  Column(
                    spacing: 5.h,
                    children: [
                      ...List.generate(orderProducts.length, (index) {
                        return Row(
                          children: [
                            Image.network(
                              orderProducts[index],
                              width: 113.w,
                              height: 93.h,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 10.w,
                              ),
                              width: 267.w,
                              height: 93.h,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkAppBar
                                    : AppColors.white,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 5.w,
                                children: [
                                  SizedBox(
                                    width: 152.w,
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      orderTitle[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 72.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          orderTitle[index],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            color: isDark
                                                ? AppColors.white
                                                : AppColors.textColor,
                                          ),
                                        ),
                                        Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          orderTitle[index],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.sp,
                                            color: AppColors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ),
              Column(
                spacing: 15.h,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: Text(
                      'Delivery status',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.borderColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 220.w,
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: DropdownButton<String>(
                      alignment: AlignmentGeometry.center,
                      borderRadius: BorderRadius.circular(10.r),
                      dropdownColor: AppColors.orange,
                      value: status,
                      underline: SizedBox(),
                      onChanged: (value) async {
                        if (value == null) return;
                        status = value;
                        setState(() {});
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'Pending',
                          child: Text(
                            'Pending',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'ru',
                          child: Text(
                            'Delivered/ Picked up',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

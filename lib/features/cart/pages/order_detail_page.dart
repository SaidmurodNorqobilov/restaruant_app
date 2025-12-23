import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final List<String> orderProducts = [
    'https://static.toiimg.com/photo/102941656.cms',
    'https://townsquare.media/site/385/files/2023/06/attachment-milkshake-.jpg?w=1200&q=75&format=natural',
    'https://townsquare.media/site/385/files/2023/06/attachment-milkshake-.jpg?w=1200&q=75&format=natural',
    'https://i.pinimg.com/originals/32/07/8e/32078e4d3c1e9edb4d76dba9a419f71f.jpg',
    'https://static.toiimg.com/photo/102941656.cms',
    'https://static.toiimg.com/photo/102941656.cms',
  ];

  final List<String> orderTitle = [
    'Provencal Breakf',
    '2 Provencal Breakf',
    '2 Provencal Breakf',
    '3 Provencal Breakf',
    '4 Provesfsdfncal Bredghdfgsdfgsgfdakf',
    '4 Provesfsdfncal Bredghdfgsdfgsgfdakf',
  ];

  String status = 'Pending';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidgets(title: 'Order Details'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem('Time:', 'Backend Time', isDark),
                      _buildInfoItem('Order Number:', 'Backend Number', isDark),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem('Order by:', 'Backend Name', isDark),
                      _buildInfoItem('Client Phone:', 'Backend data', isDark),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildInfoItem('Delivery type:', 'Backend Name', isDark),
                  SizedBox(height: 20.h),
                  _buildInfoItem('Location:', 'Backend Name', isDark),
                  SizedBox(height: 20.h),
                  _buildInfoItem('Total', '\$ Price', isDark, isPrice: true),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: const Divider(),
              ),
              Text(
                'Items (${orderProducts.length} items)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.borderColor,
                ),
              ),
              SizedBox(height: 15.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderProducts.length,
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          orderProducts[index],
                          width: 100.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 70.h,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkAppBar : AppColors.white,
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(8.r)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  orderTitle[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: isDark ? AppColors.white : AppColors.textColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Qty: 1",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isDark ? Colors.white70 : AppColors.textColor,
                                      ),
                                    ),
                                    Text(
                                      "\$25.00",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 30.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Delivery status',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.borderColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 200.w,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(15.r),
                        dropdownColor: AppColors.orange,
                        value: status,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        onChanged: (value) {
                          if (value != null) setState(() => status = value);
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Pending',
                            child: Text('Pending', style: TextStyle(color: Colors.white)),
                          ),
                          DropdownMenuItem(
                            value: 'Delivered',
                            child: Text('Delivered', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, bool isDark, {bool isPrice = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.borderColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: isPrice ? FontWeight.w700 : FontWeight.w500,
            color: isPrice
                ? AppColors.green
                : (isDark ? AppColors.white : AppColors.textColor),
          ),
        ),
      ],
    );
  }
}
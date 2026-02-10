import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/status.dart';
import '../../../../core/widgets/appbar_widgets.dart';
import '../../../../core/widgets/common_state_widgets.dart';
import '../bloc/locationBloc/location_bloc.dart';
import '../bloc/locationBloc/location_state.dart';
import 'location_page.dart';

class MyLocationsPage extends StatefulWidget {
  const MyLocationsPage({super.key});

  @override
  State<MyLocationsPage> createState() => _MyLocationsPageState();
}

class _MyLocationsPageState extends State<MyLocationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyLocationBloc>().add(MyLocationRefreshEvent());
    });
  }

  final editTitleController = TextEditingController();

  @override
  void dispose() {
    editTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: const AppBarWidgets(title: 'Mening manzillarim'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          context.push(Routes.location);
        },
        child: const Icon(
          Icons.add_location_alt_rounded,
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<MyLocationBloc, MyLocationState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return Center(child: LoadingState(isDark: isDark));
          }
          if (state.status == Status.error) {
            return Center(
              child: ErrorState(
                isDark: isDark,
                onRetry: () => context.read<MyLocationBloc>().add(
                  MyLocationRefreshEvent(),
                ),
              ),
            );
          }
          if (state.locations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 70.sp,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Manzillar topilmadi",
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
            color: AppColors.white,
            onRefresh: () async => context.read<MyLocationBloc>().add(
              MyLocationRefreshEvent(),
            ),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 100.h),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: state.locations.length,
              itemBuilder: (context, index) {
                final item = state.locations[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () {
                    _showBottomSheet(context, index, state, isDark, isTablet);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 7.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 45.w,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30.r),
                            onTap: () {
                              _showBottomSheet(context, index, state, isDark, isTablet);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showBottomSheet(
    BuildContext context,
    int index,
    MyLocationState state,
    bool isDark,
    bool isTablet,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        height: isTablet ? 350.h : 320.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAppBar : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 24.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showEditLocationDialog(context, index, state);
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkAppBar : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "Tahrirlash",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.white : AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              InkWell(
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPage(
                        mode: LocationPageMode.view,
                        locationId: state.locations[index].id,
                        initialTitle: state.locations[index].title,
                        initialAddress: state.locations[index].address,
                        initialLat: state.locations[index].lat,
                        initialLng: state.locations[index].lng,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkAppBar : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.edit_location_alt_outlined,
                          color: Colors.orange,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "Manzilni o'zgartirish",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.white : AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              InkWell(
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showDeleteDialog(context, index, state);
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkAppBar : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "O'chirish",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
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
  }

  void _showEditLocationDialog(
    BuildContext context,
    int index,
    MyLocationState state,
  ) {
    editTitleController.text = state.locations[index].title;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          width: 350.w,
          height: 240.h,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkAppBar : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Material(
            color: isDark ? AppColors.darkAppBar : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Manzil nomini tahrirlash",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  cursorColor: isDark ? AppColors.white : AppColors.textColor,
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                  controller: editTitleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                    hintText: "Manzil nomi",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10.r),
                      onTap: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 140.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Text(
                          "Bekor qilish",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.white : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10.r),
                      onTap: () {
                        if (editTitleController.text.trim().isEmpty) {
                          showTopSnackBar(
                            Overlay.of(dialogContext),
                            const CustomSnackBar.error(
                              message: "Manzil nomini kiriting",
                            ),
                          );
                          return;
                        }

                        context.read<MyLocationBloc>().add(
                          MyLocationEditEvent(
                            locationId: state.locations[index].id,
                            title: editTitleController.text.trim(),
                            address: state.locations[index].address,
                            latitude: state.locations[index].lat,
                            longitude: state.locations[index].lng,
                          ),
                        );
                        Navigator.pop(dialogContext);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 140.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "Saqlash",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    int index,
    MyLocationState state,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkAppBar : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Text(
          "Manzilni o'chirish",
          style: TextStyle(
            color: isDark ? AppColors.white : AppColors.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Haqiqatan ham bu manzilni o'chirmoqchimisiz?",
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[700],
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "Bekor qilish",
              style: TextStyle(
                color: isDark ? AppColors.white : AppColors.textColor,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<MyLocationBloc>().add(
                MyLocationDeleteEvent(locationId: state.locations[index].id),
              );
              Navigator.pop(dialogContext);
            },
            child: Text(
              "O'chirish",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

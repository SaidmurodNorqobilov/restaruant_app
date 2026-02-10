import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/routing/routes.dart';

import '../../../account/presentation/bloc/locationBloc/location_state.dart';
import '../../../account/presentation/pages/location_page.dart';

class LocationSelectionSheet extends StatefulWidget {
  final MyLocationState state;
  final String? initialSelectedId;
  final Function(String id, String address) onLocationSelected;

  const LocationSelectionSheet({
    super.key,
    required this.state,
    this.initialSelectedId,
    required this.onLocationSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required MyLocationState state,
    String? initialSelectedId,
    required Function(String id, String address) onLocationSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationSelectionSheet(
        state: state,
        initialSelectedId: initialSelectedId,
        onLocationSelected: onLocationSelected,
      ),
    );
  }

  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet> {
  String? tempSelectedId;

  @override
  void initState() {
    super.initState();
    tempSelectedId = widget.initialSelectedId;
  }

  Future<void> _saveAndConfirm(String locationId, String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_location_id', locationId);
    await prefs.setString('selected_location_address', address);

    widget.onLocationSelected(locationId, address);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAppBar : AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withAlpha(77)
                  : AppColors.textColor.withAlpha(77),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manzilni tanlang",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1.h, thickness: 1),
          Expanded(
            child: widget.state.locations.isEmpty
                ? _buildEmptyLocationState(isDark)
                : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: widget.state.locations.length,
              itemBuilder: (context, index) {
                final location = widget.state.locations[index];
                final isSelected = tempSelectedId == location.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tempSelectedId = location.id;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withAlpha(26)
                          : isDark
                          ? AppColors.textColor.withAlpha(13)
                          : AppColors.borderColor.withAlpha(77),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primary,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                location.address,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isDark
                                      ? AppColors.white.withAlpha(179)
                                      : AppColors.textColor.withAlpha(179),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationPage(
                                  mode: LocationPageMode.view,
                                  locationId: location.id,
                                  initialTitle: location.title,
                                  initialAddress: location.address,
                                  initialLat: location.lat,
                                  initialLng: location.lng,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.visibility_outlined,
                            color: AppColors.primary,
                            size: 22.sp,
                          ),
                        ),
                        Radio<String>(
                          value: location.id,
                          groupValue: tempSelectedId,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              tempSelectedId = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(Routes.location);
                  },
                  icon: Icon(
                    Icons.add_location_alt_outlined,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    "Yangi manzil qo'shish",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.h),
                    side: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: tempSelectedId == null
                      ? null
                      : () {
                    final selectedLocation = widget.state.locations
                        .firstWhere((loc) => loc.id == tempSelectedId);
                    _saveAndConfirm(
                      selectedLocation.id,
                      selectedLocation.address,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tempSelectedId == null
                        ? AppColors.primary.withAlpha(128)
                        : AppColors.primary,
                    minimumSize: Size(double.infinity, 50.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "Tasdiqlash",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyLocationState(bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off,
                size: 60.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Hech qanday manzil yo'q",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textColor,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Buyurtma berish uchun birinchi manzil qo'shing",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark
                    ? AppColors.white.withAlpha(179)
                    : AppColors.textColor.withAlpha(179),
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push(Routes.location);
              },
              icon: Icon(Icons.add_location_alt, size: 20.sp),
              label: Text(
                "Manzil qo'shish",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 14.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/features/reservations/managers/reservation_bloc.dart';

class ReservationDetailSheet {
  static void show(
    BuildContext context,
    bool isDark,
    dynamic reservation,
    ReservationBloc bloc,
  ) {
    // final reservationBloc = context.read<ReservationBloc>();

    final nameController = TextEditingController(text: reservation.name);
    final emailController = TextEditingController(text: reservation.email);
    final phoneController = TextEditingController(text: reservation.phone);
    final noteController = TextEditingController(text: reservation.specialNote);

    int selectedGuests = reservation.numberOfGuests;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20.h,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkAppBar : AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(102),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Bron tafsilotlari',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(height: 20.h),
                _DetailField(
                  label: 'Ism',
                  controller: nameController,
                  isDark: isDark,
                ),
                _DetailField(
                  label: 'Email',
                  controller: emailController,
                  isDark: isDark,
                  keyboard: TextInputType.emailAddress,
                ),
                _DetailField(
                  label: 'Telefon',
                  controller: phoneController,
                  isDark: isDark,
                  keyboard: TextInputType.phone,
                ),

                // Dropdown widgetingizda qiymat o'zgarganda selectedGuests ni yangilang
                // Agar PersonDropDownWidget-da onChanged bo'lsa:
                // PersonDropDownWidget(
                //   onChanged: (val) => selectedGuests = val,
                // ),
                _DetailField(
                  label: 'Izoh',
                  controller: noteController,
                  isDark: isDark,
                  maxLines: 3,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      bloc.add(
                        UpdateReservationEvent(
                          id: reservation.id,
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                          numberOfGuests: selectedGuests,
                          reservationTime: reservation.reservationTime,
                          specialNote: noteController.text.trim(),
                          isActive: true,
                        ),
                      );
                      Navigator.pop(sheetContext);
                    },
                    child: Text(
                      'Saqlash',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
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

class _DetailField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDark;
  final int maxLines;
  final TextInputType keyboard;

  const _DetailField({
    required this.label,
    required this.controller,
    required this.isDark,
    this.maxLines = 1,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.white.withAlpha(153)
                  : AppColors.textColor.withAlpha(153),
            ),
          ),
          SizedBox(height: 6.h),
          TextField(
            cursorColor: isDark ? AppColors.white : AppColors.primary,
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboard,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.textColor,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark
                  ? AppColors.black.withAlpha(51)
                  : AppColors.primary.withAlpha(13),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

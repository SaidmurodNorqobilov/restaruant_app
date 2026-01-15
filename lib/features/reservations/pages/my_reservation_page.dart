import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:restaurantapp/data/repositories/reservations_repository.dart';
import 'package:restaurantapp/features/common/widgets/appbar_widgets.dart';
import 'package:restaurantapp/features/reservations/managers/reservation_bloc.dart';
import 'package:restaurantapp/features/reservations/managers/reservation_state.dart';
import 'package:restaurantapp/features/reservations/pages/person_dropdown_widget.dart';

import '../../../core/utils/status.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    return BlocProvider(
      create: (context) => ReservationBloc(
        repository: ReservationRepository(
          client: ApiClient(),
        )..getReservations(),
      )..add(GetReservationsEvent()),
      child: Scaffold(
        appBar: AppBarWidgets(title: 'Mening Bronlarim'),
        body: RefreshIndicator(
          backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
          color: AppColors.white,
          onRefresh: () async {
            context.read<ReservationBloc>().add(GetReservationsEvent());
          },
          child: BlocBuilder<ReservationBloc, ReservationState>(
            builder: (context, state) {
              if (state.status == Status.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isTablet ? 100.w : 80.w,
                        height: isTablet ? 100.w : 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: isTablet ? 75.w : 60.w,
                              height: isTablet ? 75.w : 60.w,
                              child: CircularProgressIndicator(
                                strokeWidth: isTablet ? 4 : 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.restaurant_menu,
                              size: isTablet ? 35.sp : 28.sp,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 30.h : 24.h),
                      Text(
                        'Ma\'lumotlar yuklanmoqda...',
                        style: TextStyle(
                          fontSize: isTablet ? 18.sp : 16.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.white.withAlpha(179)
                              : AppColors.black.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state.reservations!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 40.w : 32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: isTablet ? 140.w : 120.w,
                          height: isTablet ? 140.w : 120.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary.withAlpha(26),
                                AppColors.primary.withAlpha(13),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chair_rounded,
                            size: isTablet ? 70.sp : 60.sp,
                            color: AppColors.primary.withAlpha(153),
                          ),
                        ),
                        SizedBox(height: isTablet ? 40.h : 32.h),
                        Text(
                          'Hozircha joy bron qilmagansiz',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isTablet ? 28.sp : 24.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        // Text(
                        //   'Bu kategoriyada hozircha mahsulotlar\nmavjud emas. Keyinroq qaytib ko\'ring!',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontSize: isTablet ? 16.sp : 14.sp,
                        //     fontWeight: FontWeight.w400,
                        //     color: isDark
                        //         ? AppColors.white.withAlpha(179)

                        //         : AppColors.black.withAlpha(153)
                        //     height: 1.5,
                        //   ),
                        // ),
                        SizedBox(height: isTablet ? 48.h : 40.h),
                        OutlinedButton.icon(
                          onPressed: () {
                            context.pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 40.w : 32.w,
                              vertical: isTablet ? 18.h : 16.h,
                            ),
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            size: isTablet ? 24.sp : 20.sp,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            'Orqaga qaytish',
                            style: TextStyle(
                              fontSize: isTablet ? 18.sp : 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.status == Status.error) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 40.w : 32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: isTablet ? 120.w : 100.w,
                          height: isTablet ? 120.w : 100.w,
                          decoration: BoxDecoration(
                            color: AppColors.red.withAlpha(26),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: isTablet ? 60.sp : 50.sp,
                            color: AppColors.red,
                          ),
                        ),
                        SizedBox(height: isTablet ? 30.h : 24.h),
                        Text(
                          'Xatolik yuz berdi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isTablet ? 24.sp : 20.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        SizedBox(height: isTablet ? 16.h : 12.h),
                        Text(
                          'Ma\'lumotlarni yuklashda muammo yuz berdi.\nKeyinroq qaytadan urinib ko\'ring.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isTablet ? 16.sp : 14.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.white.withAlpha(179)
                                : AppColors.black.withAlpha(153),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: isTablet ? 40.h : 32.h),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<ReservationBloc>().add(
                              GetReservationsEvent(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 40.w : 32.w,
                              vertical: isTablet ? 18.h : 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(
                            Icons.refresh_rounded,
                            size: isTablet ? 24.sp : 20.sp,
                            color: AppColors.white,
                          ),
                          label: Text(
                            'Qayta urinish',
                            style: TextStyle(
                              fontSize: isTablet ? 18.sp : 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }


              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                itemCount: state.reservations!.length,
                itemBuilder: (context, index) {
                  final reservation = state.reservations![index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                AppColors.darkAppBar,
                                AppColors.darkAppBar..withAlpha(204),
                              ]
                            : [
                                AppColors.white,
                                AppColors.white.withAlpha(230),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(51),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(26),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withAlpha(179),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.restaurant_menu,
                                color: AppColors.white,
                                size: 30.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bron #${reservation.id}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors.textColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14.sp,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        reservation.reservationTime,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: isDark
                                              ? AppColors.white.withAlpha(179)
                                              : AppColors.textColor.withAlpha(179)

                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Colors.green.withAlpha(26)
                                    : Colors.orange.withAlpha(26),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: index % 2 == 0
                                      ? Colors.green.withAlpha(77)
                                      : Colors.orange.withAlpha(77),
                                ),
                              ),
                              child: Text(
                                index % 2 == 0 ? 'Faol' : 'Kutilmoqda',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: index % 2 == 0
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Divider(
                          color: isDark
                              ? AppColors.white.withAlpha(26)
                              : AppColors.textColor.withAlpha(26),
                        ),
                        SizedBox(height: 12.h),
                        _buildInfoRow(
                          isDark,
                          Icons.person_outline,
                          'Ism',
                          reservation.name,
                        ),
                        SizedBox(height: 10.h),
                        _buildInfoRow(
                          isDark,
                          Icons.email_outlined,
                          'Email',
                          reservation.email,
                        ),
                        SizedBox(height: 10.h),
                        _buildInfoRow(
                          isDark,
                          Icons.phone_outlined,
                          'Telefon',
                          reservation.phoneNumber,
                        ),
                        SizedBox(height: 10.h),
                        _buildInfoRow(
                          isDark,
                          Icons.people_outline,
                          'Mehmonlar',
                          '${reservation.numberOfGuests} kishi',
                        ),
                        if (index % 3 == 0) ...[
                          SizedBox(height: 10.h),
                          _buildInfoRow(
                            isDark,
                            Icons.note_outlined,
                            'Izoh',
                            reservation.specialNote,
                          ),
                        ],
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red.withAlpha(77),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10.r),
                                    onTap: () {
                                      context.read<ReservationBloc>().add(
                                        CancelReservationEvent(
                                          id: reservation.id,
                                        ),
                                      );
                                      context.read<ReservationBloc>().add(
                                        GetReservationsEvent(),
                                      );
                                    },
                                    // AGAR FAOL BO'LSA
                                    // BEKOR QILISHDAN OLIN YANA BIR MARTA SORASH KERAK
                                    child: Center(
                                      child: Text(
                                        'Bekor qilish',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primary..withAlpha(204),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withAlpha(77),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10.r),
                                    onTap: () {
                                      _showReservationDetailSheet(
                                        context,
                                        isDark,
                                        reservation,
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        'Batafsil',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pop(context),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: AppColors.white),
          label: Text(
            'Yangi bron',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showReservationDetailSheet(
    BuildContext context,
    bool isDark,
    reservation,
  ) {
    final nameController = TextEditingController(text: reservation.name);
    final emailController = TextEditingController(text: reservation.email);
    final phoneController = TextEditingController(
      text: reservation.phoneNumber,
    );
    final guestsController = TextEditingController(
      text: reservation.numberOfGuests.toString(),
    );
    final noteController = TextEditingController(text: reservation.specialNote);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
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
                      color: Colors.grey.withAlpha(102)
,
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
                _detailField('Ism', nameController, isDark),
                _detailField('Email', emailController, isDark),
                _detailField('Telefon', phoneController, isDark),
                PersonDropDownWidget(),
                _detailField(
                  'Izoh',
                  noteController,
                  isDark,
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
                      context.read<ReservationBloc>().add(
                        UpdateReservationEvent(
                          id: reservation.id,
                          name: nameController.text,
                          email: emailController.text,
                          phoneNumber: phoneController.text,
                          numberOfGuests: int.parse(guestsController.text),
                          reservationTime: reservation.reservationTime,
                          specialNote: noteController.text,
                          isActive: true,
                        ),
                      );

                      Navigator.pop(context);
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

  Widget _detailField(
    String label,
    TextEditingController controller,
    bool isDark, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
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

  Widget _buildInfoRow(
    bool isDark,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: AppColors.primary.withAlpha(179),
        ),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.white.withAlpha(153)
                : AppColors.textColor.withAlpha(153),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

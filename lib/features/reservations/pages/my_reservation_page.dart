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
import '../../../core/utils/status.dart';
import '../../common/widgets/common_state_widgets.dart';
import '../widgets/build_info_row_widget.dart';
import '../widgets/reservation_detail_sheet_widget.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  @override
  void initState() {
    context.read<ReservationBloc>().add(GetReservationsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    return Scaffold(
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
              return LoadingState(
                isDark: isDark,
                isTablet: isTablet,
                icon: Icons.shopping_cart,
                message: 'Ma\'lumotlar yuklanmoqda...',
              );
            }

            if (state.reservations!.isEmpty) {
              return EmptyState(
                isDark: isDark,
                isTablet: isTablet,
                icon: Icons.inbox,
                title: 'Joy bron qilmagansiz',
                subtitle: 'Bron qilishni boshlang',
                buttonText: 'Bron qilish',
                onPressed: () => context.pop(),
              );
            }

            if (state.status == Status.error) {
              return ErrorState(
                isDark: isDark,
                isTablet: isTablet,
                title: 'Xatolik yuz berdi',
                message: 'Qayta urinib ko\'ring',
                buttonText: 'Qayta urinish',
                onRetry: () => context.read<ReservationBloc>().add(
                  GetReservationsEvent(),
                ),
              );
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
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
                              AppColors.darkAppBar.withAlpha(204),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      reservation.reservationTime,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: isDark
                                            ? AppColors.white.withAlpha(179)
                                            : AppColors.textColor.withAlpha(
                                                179,
                                              ),
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
                      ReservationInfoRow(
                        isDark: isDark,
                        icon: Icons.person_outline,
                        label: 'Ism',
                        value: reservation.name,
                      ),
                      SizedBox(height: 10.h),
                      ReservationInfoRow(
                        isDark: isDark,
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: reservation.email,
                      ),
                      SizedBox(height: 10.h),
                      ReservationInfoRow(
                        isDark: isDark,
                        icon: Icons.phone_outlined,
                        label: 'Telefon',
                        value: reservation.phone,
                      ),
                      SizedBox(height: 10.h),
                      ReservationInfoRow(
                        isDark: isDark,
                        icon: Icons.people_outline,
                        label: 'Mehmonlar',
                        value: '${reservation.numberOfGuests} kishi',
                      ),
                      if (reservation.specialNote.isNotEmpty) ...[
                        SizedBox(height: 10.h),
                        ReservationInfoRow(
                          isDark: isDark,
                          icon: Icons.note_outlined,
                          label: 'Izoh',
                          value: reservation.specialNote,
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
                                  },
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
                                    AppColors.primary.withAlpha(204),
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
                                    final bloc = context
                                        .read<ReservationBloc>();
                                    ReservationDetailSheet.show(
                                      context,
                                      isDark,
                                      reservation,
                                      bloc,
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
    );
  }
}

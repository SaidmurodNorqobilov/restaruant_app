import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:restaurantapp/core/routing/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class PaymentHandler {
  static Future<void> handleClickPayment({
    required BuildContext context,
    required String paymentUrl,
    required String transactionId,
    VoidCallback? onCancel,
  }) async {
    try {
      final Uri uri = Uri.parse(paymentUrl);

      final bool canLaunch = await canLaunchUrl(uri);

      if (!canLaunch) {
        if (context.mounted) {
          _showErrorModal(context, "To'lov tizimini ochib bo'lmadi", onCancel);
        }
        return;
      }

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        if (context.mounted) {
          _showErrorModal(context, "To'lov tizimini ochib bo'lmadi", onCancel);
        }
        return;
      }

      if (context.mounted) {
        _showPaymentStatusCheckModal(context, transactionId, onCancel);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorModal(context, "Xatolik", onCancel);
      }
    }
  }

  static void showPaymentStatusCheckModalStatic(
    BuildContext context,
    String transactionId,
    VoidCallback? onCancel,
  ) {
    _showPaymentStatusCheckModal(context, transactionId, onCancel);
  }

  static void _showPaymentStatusCheckModal(
    BuildContext context,
    String transactionId,
    VoidCallback? onCancel,
  ) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    context.push(Routes.orders);
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext dialogContext) {
    //     return Dialog(
    //       backgroundColor: Colors.transparent,
    //       child: Container(
    //         padding: EdgeInsets.all(24.w),
    //         decoration: BoxDecoration(
    //           color: isDark ? AppColors.darkAppBar : AppColors.white,
    //           borderRadius: BorderRadius.circular(20.r),
    //         ),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Icon(
    //               Icons.info_outline,
    //               size: 48.sp,
    //               color: AppColors.primary,
    //             ),
    //             SizedBox(
    //               height: 16.h,
    //             ),
    //             Text(
    //               "To'lovni amalga oshirdingizmi?",
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 fontSize: 16.sp,
    //                 fontWeight: FontWeight.w600,
    //                 color: isDark ? AppColors.white : AppColors.textColor,
    //               ),
    //             ),
    //             SizedBox(height: 24.h),
    //             Row(
    //               children: [
    //                 Expanded(
    //                   child: OutlinedButton(
    //                     onPressed: () {
    //                       Navigator.of(dialogContext).pop();
    //                       if (onCancel != null) {
    //                         onCancel();
    //                       } else {
    //                         context.push(Routes.orders);
    //                       }
    //                     },
    //                     style: OutlinedButton.styleFrom(
    //                       side: BorderSide(color: Colors.grey, width: 1.5),
    //                       foregroundColor: Colors.grey,
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(12.r),
    //                       ),
    //                       padding: EdgeInsets.symmetric(vertical: 12.h),
    //                     ),
    //                     child: Text(
    //                       "Buyurtmalarga o'tish",
    //                       style: TextStyle(
    //                         fontSize: 14.sp,
    //                         fontWeight: FontWeight.w600,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(width: 12.w),
    //                 Expanded(
    //                   child: ElevatedButton(
    //                     onPressed: () {
    //                       Navigator.of(dialogContext).pop();
    //                       _checkPaymentStatus(context, transactionId, onCancel);
    //                     },
    //                     style: ElevatedButton.styleFrom(
    //                       backgroundColor: AppColors.primary,
    //                       foregroundColor: Colors.white,
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(12.r),
    //                       ),
    //                       padding: EdgeInsets.symmetric(vertical: 12.h),
    //                     ),
    //                     child: Text(
    //                       "Tekshirish",
    //                       style: TextStyle(
    //                         fontSize: 14.sp,
    //                         fontWeight: FontWeight.w600,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  static Future<void> _checkPaymentStatus(
    BuildContext context,
    String transactionId,
    VoidCallback? onCancel,
  ) async {
    _showLoadingModal(context, "To'lov holati tekshirilmoqda...");

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://45.138.158.158:3003/transactions/$transactionId/status',
      );

      if (!context.mounted) return;
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final status = response.data['status'];

        if (status == 'COMPLETED' || status == 'SUCCESS' || status == 'PAID') {
          if (context.mounted) {
            if (onCancel != null) {
              onCancel();
            }
            context.push(
              Routes.success,
              extra: {
                'message':
                    'Buyurtma va to\'lov muvaffaqiyatli amalga oshirildi',
                'appbarTitle': 'To\'lov muvaffaqiyatli',
              },
            );
          }
        } else if (status == 'PENDING') {
          if (context.mounted) {
            _showPendingModal(context, transactionId, onCancel);
          }
        } else {
          if (context.mounted) {
            _showErrorModal(context, "To'lov amalga oshmadi.", onCancel);
          }
        }
      } else {
        if (context.mounted) {
          _showErrorModal(
            context,
            "To'lov holatini tekshirib bo'lmadi",
            onCancel,
          );
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      _showErrorModal(
        context,
        "Xatolik yuz berdi. Iltimos qayta urinib ko'ring",
        onCancel,
      );
    }
  }

  static void _showPendingModal(
    BuildContext context,
    String transactionId,
    VoidCallback? onCancel,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.pending_outlined,
                  size: 48.sp,
                  color: Colors.orange,
                ),
                SizedBox(height: 16.h),
                Text(
                  "To'lov kutilmoqda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "To'lov hali tasdiqlanmagan. Iltimos kutib turing va qaytadan tekshiring",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark
                        ? AppColors.white.withAlpha(179)
                        : AppColors.textColor.withAlpha(179),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          if (onCancel != null) {
                            onCancel();
                          }
                          context.push(Routes.orders);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey, width: 1.5),
                          foregroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          "Buyurtmalarga o'tish",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          Future.delayed(const Duration(seconds: 2), () {
                            _checkPaymentStatus(
                              context,
                              transactionId,
                              onCancel,
                            );
                           }
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          "Qayta tekshirish",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showLoadingModal(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                SizedBox(height: 20.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showErrorModal(
    BuildContext context,
    String message,
    VoidCallback? onCancel,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAppBar : AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.textColor,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      if (onCancel != null) {
                        onCancel();
                      }
                      context.push(Routes.orders);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      "Buyurtmalarga o'tish",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
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

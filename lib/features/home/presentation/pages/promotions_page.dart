// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:restaurantapp/core/client.dart';
// import 'package:restaurantapp/core/utils/app_colors.dart';
// import 'package:restaurantapp/core/utils/status.dart';
// import 'package:restaurantapp/data/repositories/category_repositories.dart';
// import 'package:restaurantapp/features/home/managers/categoriesBloc/categories_bloc.dart';
// import 'package:restaurantapp/features/home/managers/categoriesBloc/categories_state.dart';
//
// class PromotionsPage extends StatefulWidget {
//   final String id;
//
//   const PromotionsPage({super.key, required this.id});
//
//   @override
//   State<PromotionsPage> createState() => _PromotionsPageState();
// }
//
// class _PromotionsPageState extends State<PromotionsPage> {
//   final String baseUrl = "https://atsrestaurant.pythonanywhere.com";
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Promotions'),
//         backgroundColor: isDark ? AppColors.darkAppBar : AppColors.primary,
//         foregroundColor: AppColors.white,
//       ),
//       body: BlocProvider(
//         create: (context) => CategoriesBLoc(
//           categoryRepository: CategoryRepository(client: ApiClient()),
//         )..add(CategoryGetId(widget.id)),
//         child: BlocBuilder<CategoriesBLoc, CategoriesState>(
//           builder: (context, state) {
//             if (state.status == Status.loading) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 80.w,
//                       height: 80.w,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withAlpha(21),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           SizedBox(
//                             width: 60.w,
//                             height: 60.w,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 3,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 AppColors.primary,
//                               ),
//                             ),
//                           ),
//                           Icon(
//                             Icons.restaurant_menu,
//                             size: 28.sp,
//                             color: AppColors.primary,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 24.h),
//                     Text(
//                       'Mahsulotlar yuklanmoqda...',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: isDark
//                             ? AppColors.white.withAlpha(179)
//                             : AppColors.black.withOpacity(0.6),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             if (state.status == Status.error && state.products.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       size: 64.sp,
//                       color: Colors.red,
//                     ),
//                     SizedBox(height: 16.h),
//                     Text(
//                       "Xatolik yuz berdi",
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: isDark ? AppColors.white : AppColors.textColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             if (state.status == Status.success && state.products.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.inbox_outlined,
//                       size: 64.sp,
//                       color: isDark ? AppColors.white : Colors.grey,
//                     ),
//                     SizedBox(height: 16.h),
//                     Text(
//                       "Hozircha mahsulotlar yo'q",
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: isDark ? AppColors.white : AppColors.textColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             return RefreshIndicator(
//               backgroundColor: isDark ? AppColors.darkAppBar : AppColors.white,
//               color: AppColors.primary,
//               onRefresh: () async {
//                 context.read<CategoriesBLoc>().add(CategoryGetId(widget.id));
//               },
//               child: ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 20.w,
//                   vertical: 20.h,
//                 ),
//                 itemCount: state.products.length,
//                 itemBuilder: (context, index) {
//                   final product = state.products[index];
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 14.h),
//                     child: GestureDetector(
//                       onTap: () {
//                         // Mahsulot detailsiga utish
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? AppColors.darkAppBar
//                               : AppColors.white,
//                           borderRadius: BorderRadius.circular(12.r),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 10,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         clipBehavior: Clip.antiAlias,
//                         child: Row(
//                           children: [
//                             Image.network(
//                               product.image.startsWith('http')
//                                   ? product.image
//                                   : "$baseUrl${product.image}",
//                               width: 130.w,
//                               height: 105.h,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Container(
//                                     width: 130.w,
//                                     height: 105.h,
//                                     color: Colors.grey.shade300,
//                                     child: const Icon(Icons.broken_image),
//                                   ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: EdgeInsets.all(15.w),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       product.name,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 15.sp,
//                                         color: isDark
//                                             ? AppColors.white
//                                             : AppColors.textColor,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 8.h,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             "SO'M ${product.finalPrice}",
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 14.sp,
//                                               color: AppColors.primary,
//                                             ),
//                                           ),
//                                         ),
//                                         if (product.discount != null)
//                                           Container(
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: 8.w,
//                                               vertical: 4.h,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.green
//                                                   .withOpacity(0.1),
//                                               borderRadius:
//                                                   BorderRadius.circular(6.r),
//                                             ),
//                                             child: Text(
//                                               "${product.discount}%",
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 12.sp,
//                                                 color: AppColors.green,
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

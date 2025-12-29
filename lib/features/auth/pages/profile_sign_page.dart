import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantapp/core/utils/colors.dart';

import '../../../core/routing/routes.dart';
import '../widgets/custom_drop_down_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/profile_avatar_widget.dart';

class ProfileSignPage extends StatefulWidget {
  const ProfileSignPage({super.key});

  @override
  State<ProfileSignPage> createState() => _ProfileSignPageState();
}

class _ProfileSignPageState extends State<ProfileSignPage> {


  final ismController = TextEditingController();
  final familiyaController = TextEditingController();
  String? tanlanganViloyat;
  File? rasm;

  // String get phoneNumber {
  //   try {
  //     final value = widget.extra['phoneNumber'] ??
  //         widget.extra['phone_number'] ??
  //         '';
  //     return value is String ? value : '';
  //   } catch (e) {
  //     return '';
  //   }
  // }

  // bool get isNewUser {
  //   try {
  //     final value = widget.extra['isNewUser'] ?? true;
  //     return value is bool ? value : true;
  //   } catch (e) {
  //     return true;
  //   }
  // }

  final viloyatlar = {
    'Toshkent': 1,
    'Samarqand': 2,
    'Farg\'ona': 3,
    'Buxoro': 4,
    'Namangan': 5,
    'Xorazm': 6,
    'Qashqadaryo': 7,
    'Surxondaryo': 8,
    'Andijon': 9,
    'Jizzax': 10,
    'Navoiy': 11,
    'Sirdaryo': 12,
    'Qoraqalpog\'iston': 13,
  };

  Future<void> _rasmTanlash() async {
    final picker = ImagePicker();
    final tanlangan = await picker.pickImage(source: ImageSource.gallery);
    if (tanlangan != null) {
      setState(() {
        rasm = File(tanlangan.path);
      });
    }
  }

  @override
  void dispose() {
    ismController.dispose();
    familiyaController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 48.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24.h,
          children: [
            ProfileAvatarWidget(
              imageFile: rasm,
              onTap: _rasmTanlash,
            ),
            CustomTextFeldWidget(
              controller: ismController,
              hintText: "Ismingiz",
            ),
            CustomTextFeldWidget(
              controller: familiyaController,
              hintText: "Familyangiz",
            ),
            CustomDropDownWidget(
              value: tanlanganViloyat,
              hintText: "Viloyatingiz",
              items: viloyatlar.keys
                  .map((v) => DropdownMenuItem(
                value: v,
                child: Text(v),
              ))
                  .toList(),
              onChanged: (yangi) => setState(() => tanlanganViloyat = yangi),
            ),
            const Spacer(),
            // BlocBuilder<AuthBloc, AuthState>(
            //   builder: (context, state) {
            //     final isLoading = state is AuthLoading;
            //     return TextButtonPopular(
            //       onPressed: () {
            //         if (isLoading) return;
            //
            //         if (ismController.text.isEmpty ||
            //             familiyaController.text.isEmpty ||
            //             tanlanganViloyat == null) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             const SnackBar(
            //               content: Text('Barcha maydonlarni to\'ldiring'),
            //             ),
            //           );
            //           return;
            //         }
            //
            //         if (phoneNumber.isEmpty) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             const SnackBar(
            //               content: Text(
            //                   'Telefon raqam topilmadi. Qaytadan kiriting.'),
            //               backgroundColor: Colors.orange,
            //             ),
            //           );
            //           return;
            //         }
            //
            //         final regionId = viloyatlar[tanlanganViloyat];
            //
            //         context.read<AuthBloc>().add(
            //           UpdateProfileEvent(
            //             firstName: ismController.text.trim(),
            //             lastName: familiyaController.text.trim(),
            //             region: regionId.toString(),
            //             profileImage: rasm,
            //             phoneNumber: phoneNumber,
            //             isNewUser: isNewUser,
            //           ),
            //         );
            //       },
            //       title: isLoading ? 'Saqlanmoqda...' : 'Saqlash',
            //     );
            //   },
            // ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                    Routes.home,
                  );
                  // if (pinController.text.length == 4) {
                  //   debugPrint('Tasdiqlash: ${pinController.text}');
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tasdiqlash',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextButtonApp extends StatefulWidget {

  final VoidCallback onPressed;
  final String text;
  final int? width;
  final int? height;
  final int? border;
  final Color textColor;
  final Color buttonColor;

  const TextButtonApp({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    required this.textColor,
    required this.buttonColor,
    this.border,
  });

  @override
  State<TextButtonApp> createState() => _TextButtonAppState();
}

class _TextButtonAppState extends State<TextButtonApp> {

  // late AnimationController _animationController;
  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 3),
  //   )..repeat();
  // }
  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        width: (widget.width ?? double.infinity).w,
        height: (widget.height ?? 50).h,
        decoration: BoxDecoration(
          color: widget.buttonColor,
          borderRadius: BorderRadius.circular((widget.border ?? 100).r)
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}

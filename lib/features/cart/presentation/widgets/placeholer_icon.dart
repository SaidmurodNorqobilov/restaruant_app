import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderIcon extends StatelessWidget {
  final bool isDark;
  final IconData? icon;
  final double? size;

  const PlaceholderIcon({
    Key? key,
    required this.isDark,
    this.icon,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Colors.white10 : Colors.grey[200],
      child: Icon(
        icon ?? Icons.fastfood_rounded,
        color: isDark ? Colors.white30 : Colors.grey[400],
        size: size ?? 30.r,
      ),
    );
  }
}
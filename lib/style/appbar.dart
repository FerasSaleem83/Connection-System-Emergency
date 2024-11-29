// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyleAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  final Widget? actionBar;

  StyleAppBar({
    Key? key,
    required this.title,
    this.actionBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // لون النص في الشريط العلوي خمري
      foregroundColor: const Color.fromARGB(255, 106, 3, 3),

      // تغيير لون الشريط
      backgroundColor: const Color.fromARGB(223, 255, 255, 255),

      // اضافة نص للشريط
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp, // حجم النص استجابة لحجم الشاشة
        ),
      ),
      // جعل النص في منتصف الشريط
      centerTitle: true,
      actions: actionBar != null ? [actionBar!] : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight.h); // ارتفاع الشريط استجابة لحجم الشاشة
}

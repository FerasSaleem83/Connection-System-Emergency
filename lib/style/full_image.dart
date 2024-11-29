import 'package:cse/style/appbar.dart';
import 'package:cse/style/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleAppBar(title: 'CSE'),

      // وضع الخصائص للصفحة
      body: BackgroundColor(
        child: Center(
          child: Image.network(
            imageUrl,
            width: 300.w,
            height: 300.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

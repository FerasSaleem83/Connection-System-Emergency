// ignore_for_file: library_private_types_in_public_api

import 'package:cse/auth_screen.dart';
import 'package:cse/style/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 5),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundColor(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 250.w,
              height: 250.h,
            ),
            SizedBox(height: 20.h),
            Center(
              child: Column(
                children: [
                  Text(
                    'CSE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

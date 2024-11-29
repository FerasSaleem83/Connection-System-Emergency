// ignore_for_file: must_be_immutable

import 'package:cse/admin_screen.dart';
import 'package:cse/auth_screen.dart';
import 'package:cse/style/background.dart';
import 'package:cse/driver_screen.dart';
import 'package:cse/user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckAccount extends StatefulWidget {
  String username;
  String userType;

  CheckAccount({required this.username, required this.userType, Key? key})
      : super(key: key);

  @override
  State<CheckAccount> createState() => _CheckAccountState();
}

class _CheckAccountState extends State<CheckAccount> {
  String _greetingMessage = '';
  // var color;
  @override
  void initState() {
    super.initState();
    _setGreetingMessage();
    widget.username;
    widget.userType;
  }

  void _setGreetingMessage() {
    final currentTime = DateTime.now();
    final int currentHour = currentTime.hour;

    if (currentHour >= 6 && currentHour < 18) {
      setState(() {
        _greetingMessage = 'Good Morning';
      });
    } else {
      setState(() {
        _greetingMessage = 'Good Night';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundColor(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70.h),
                  Image.asset(
                    'assets/images/man.png',
                    width: 175.w,
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    _greetingMessage,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 100.h),
                  SizedBox(
                    width: 300.w,
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.userType == 'user') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserPage(),
                            ),
                          );

                          return;
                        } else if (widget.userType == 'admin') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminPage(),
                            ),
                          );
                        } else if (widget.userType == 'driver') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DriverPage(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.w),
                          ),
                        ),
                      ),
                      child: Text(
                        'Continue As ${widget.username}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  SizedBox(
                    width: 300.w,
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.w),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Use Another Account',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

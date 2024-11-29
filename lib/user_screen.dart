import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/auth_screen.dart';
import 'package:cse/splash_screen.dart';
import 'package:cse/style/appBar.dart';
import 'package:cse/style/background.dart';
import 'package:cse/create_report.dart';
import 'package:cse/style/drawer.dart';
import 'package:cse/tracking.dart';
import 'package:cse/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> futureBuilder;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUsers() async {
    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('all_users_information')
        .doc(userId)
        .collection('info')
        .doc(userId)
        .get();

    return snapshot;
  }

  @override
  void initState() {
    futureBuilder = getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: futureBuilder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('خطأ'),
              content: Text('الخطأ هو: ${snapshot.error}'),
            );
          } else if (snapshot.data == null) {
            return const AlertDialog(
              title: Text('خطأ'),
              content: Text('لا يوجد بيانات'),
            );
          } else {
            String phone = snapshot.data!['Phone'];
            String userId = snapshot.data!['ID'];

            return Scaffold(
              appBar: StyleAppBar(title: 'CSE'),
              drawer: const MyDrawer(),
              body: BackgroundColor(
                child: Column(
                  children: [
                    const Divider(
                      //لون الخط
                      color: Color.fromARGB(255, 81, 0, 0),
                      // عرض الخط
                      thickness: 3.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 200.w,
                            height: 200.h,
                          ),
                          SizedBox(height: 25.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 135.w,
                                height: 150.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateReport(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    padding: EdgeInsets.all(16.w),
                                    shape: const BeveledRectangleBorder(),
                                  ),
                                  child: Text(
                                    'CREATE REPORT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              SizedBox(
                                width: 125.w,
                                height: 150.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Tracking(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    padding: EdgeInsets.all(10.w),
                                    shape: const BeveledRectangleBorder(),
                                  ),
                                  child: Text(
                                    'TRACKING',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 135.w,
                                height: 150.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateProfile(
                                          phone: phone,
                                          userId: userId,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    padding: EdgeInsets.all(16.w),
                                    shape: const BeveledRectangleBorder(),
                                  ),
                                  child: Text(
                                    'EDIT PROFILE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              SizedBox(
                                width: 125.w,
                                height: 150.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    padding: EdgeInsets.all(10.w),
                                    shape: const BeveledRectangleBorder(),
                                  ),
                                  child: Text(
                                    'LOGOUT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}

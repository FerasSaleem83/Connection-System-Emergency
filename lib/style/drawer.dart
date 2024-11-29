// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:cse/auth_screen.dart';
import 'package:cse/emergency_numbers.dart';
import 'package:cse/first_aids.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // تغيير لون الخلفية للقائمة الجانبية
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 35.h), // استخدام `h` لجعل الارتفاع نسبي
          ListTile(
            title: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirstAidsPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.add_box,
                color: Colors.grey,
              ),
              label: Text(
                'First Aids',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp, // استخدام `sp` لجعل حجم النص نسبي
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          ListTile(
            title: TextButton.icon(
              onPressed: () async {
                await _launchGPSNavigation();
              },
              icon: const Icon(
                Icons.home_work_rounded,
                color: Colors.grey,
              ),
              label: Text(
                'Nearest Center',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          ListTile(
            title: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmergencyNumbers(),
                  ),
                );
              },
              icon: const Icon(
                Icons.phone,
                color: Colors.grey,
              ),
              label: Text(
                'Emergency Numbers',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          ListTile(
            title: TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              label: Text(
                'Log Out',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          ListTile(
            title: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
              label: Text(
                'Back To Home',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchGPSNavigation() async {
    const url =
        'https://www.google.com/maps/search/%D9%85%D8%B1%D8%A7%D9%83%D8%B2+%D8%A7%D9%84%D8%AF%D9%81%D8%A7%D8%B9+%D8%A7%D9%84%D9%85%D8%AF%D9%86%D9%8A%E2%80%AD/@32.1147382,36.126475,13z/data=!3m1!4b1?entry=ttu';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

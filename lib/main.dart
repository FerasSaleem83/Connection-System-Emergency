import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cse/firebase_options.dart';
import 'package:cse/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestLocationPermission();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

Future<void> _requestLocationPermission() async {
  final PermissionStatus status = await Permission.location.request();
  if (status != PermissionStatus.granted) {
    await Permission.location.request();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CSE',
          home: SplashScreen(),
        );
      },
    );
  }
}

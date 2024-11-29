// ignore_for_file: use_build_context_synchronously

import 'package:cse/auth_screen.dart';
import 'package:cse/style/background.dart';
import 'package:cse/registeration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _firebase = FirebaseAuth.instance;
  final _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isUploading = false;

  void _login() async {
    try {
      setState(() {
        _isUploading = true;
      });
      // You can now use _isAdminSelected and _isDriverSelected in your login logic
      await _firebase.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Email or Password is incorrect'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );

      setState(() {
        _isUploading = false;
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
              padding: EdgeInsets.all(15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70.h),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 240.w,
                  ),
                  SizedBox(height: 25.h),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                fontSize: 15.sp,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.w, horizontal: 12.h),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            controller: _emailController,
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'password',
                              hintStyle: TextStyle(fontSize: 15.sp),
                              fillColor: Colors.white,
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.w, horizontal: 12.h),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                            controller: _passwordController,
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      if (_isUploading)
                        const CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      if (!_isUploading)
                        SizedBox(
                          width: 300.w,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.w),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 25.h),
                      if (!_isUploading)
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Registeration(),
                              ),
                            );
                          },
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

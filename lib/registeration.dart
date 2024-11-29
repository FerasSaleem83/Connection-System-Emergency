// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/auth_screen.dart';
import 'package:cse/style/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum UserType { user, admin, driver }

class Registeration extends StatefulWidget {
  const Registeration({Key? key}) : super(key: key);

  @override
  State<Registeration> createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  final _firebase = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _socialSecurityNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  UserType? userType;

  var _isUploading = false;

  void _submit() async {
    try {
      setState(() {
        _isUploading = true;
      });
      if (userType == UserType.admin) {
        final UserCredential userCredential =
            await _firebase.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _socialSecurityNumberController.text.trim(),
        );
        await FirebaseFirestore.instance
            .collection('all_users_information')
            .doc(userCredential.user!.uid)
            .collection('info')
            .doc(userCredential.user!.uid)
            .set({
          'Name': _nameController.text.trim(),
          'Phone': _phoneController.text.trim(),
          'Email': _emailController.text.trim(),
          'SocialSecurityNumber': _socialSecurityNumberController.text.trim(),
          'type': 'admin',
          'ID': userCredential.user!.uid,
        });
        await FirebaseFirestore.instance
            .collection('admins')
            .doc(userCredential.user!.uid)
            .set({
          'Name': _nameController.text.trim(),
          'Phone': _phoneController.text.trim(),
          'Email': _emailController.text.trim(),
          'SocialSecurityNumber': _socialSecurityNumberController.text.trim(),
          'type': 'admin',
          'ID': userCredential.user!.uid,
        });
      } else if (userType == UserType.user) {
        final UserCredential userCredential =
            await _firebase.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _socialSecurityNumberController.text.trim(),
        );
        await FirebaseFirestore.instance
            .collection('all_users_information')
            .doc(userCredential.user!.uid)
            .collection('info')
            .doc(userCredential.user!.uid)
            .set({
          'Name': _nameController.text.trim(),
          'Phone': _phoneController.text.trim(),
          'Email': _emailController.text.trim(),
          'SocialSecurityNumber': _socialSecurityNumberController.text.trim(),
          'type': 'user',
          'ID': userCredential.user!.uid,
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'Name': _nameController.text.trim(),
          'Phone': _phoneController.text.trim(),
          'Email': _emailController.text.trim(),
          'SocialSecurityNumber': _socialSecurityNumberController.text.trim(),
          'type': 'user',
          'ID': userCredential.user!.uid,
        });
      } else if (userType == UserType.driver) {
        final UserCredential userCredential =
            await _firebase.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _socialSecurityNumberController.text.trim(),
        );
        await FirebaseFirestore.instance
            .collection('all_users_information')
            .doc(userCredential.user!.uid)
            .collection('info')
            .doc(userCredential.user!.uid)
            .set({
          'Name': _nameController.text.trim(),
          'Phone': _phoneController.text.trim(),
          'Email': _emailController.text.trim(),
          'SocialSecurityNumber': _socialSecurityNumberController.text.trim(),
          'type': 'driver',
          'avilable': 'avilable',
          'ID': userCredential.user!.uid,
        });
        await FirebaseFirestore.instance
            .collection('drivers')
            .doc(userCredential.user!.uid)
            .set({
          'Name': _nameController.text.trim(),
          'Phone': _phoneController.text.trim(),
          'Email': _emailController.text.trim(),
          'SocialSecurityNumber': _socialSecurityNumberController.text.trim(),
          'type': 'driver',
          'avilable': 'avilable',
          'ID': userCredential.user!.uid,
        });
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('$e'),
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
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          TextFormField(
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.sp),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
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
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            controller: _nameController,
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phone:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          TextFormField(
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.sp),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
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
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.sp),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(fontSize: 15.sp),
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
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
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
                            keyboardType: TextInputType.number,
                            controller: _socialSecurityNumberController,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      RadioListTile<UserType>(
                        title: const Text('مستخدم'),
                        value: UserType.user,
                        groupValue: userType,
                        onChanged: (value) {
                          setState(() {
                            userType = value!;
                          });
                        },
                      ),
                      SizedBox(height: 10.h),
                      RadioListTile<UserType>(
                        title: const Text('ادمن'),
                        value: UserType.admin,
                        groupValue: userType,
                        onChanged: (value) {
                          setState(() {
                            userType = value!;
                          });
                        },
                      ),
                      RadioListTile<UserType>(
                        title: const Text('السائق'),
                        value: UserType.driver,
                        groupValue: userType,
                        onChanged: (value) {
                          setState(() {
                            userType = value!;
                          });
                        },
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(height: 15.h),
                      if (_isUploading)
                        const CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      if (!_isUploading)
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            child: const Text(
                              'CONTINUE',
                              style: TextStyle(
                                color: Colors.white,
                              ),
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

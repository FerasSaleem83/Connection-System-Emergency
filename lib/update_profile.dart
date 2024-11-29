// ignore_for_file: unused_field, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/style/appBar.dart';
import 'package:cse/style/background.dart';
import 'package:cse/user_image_galary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateProfile extends StatefulWidget {
  final String userId;
  final String phone;

  const UpdateProfile({
    required this.phone,
    required this.userId,
    super.key,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String imagepersonal =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShB7IwN9gr4q2Tn-1CRfbgANRN-8SWlYMMy9iq467T1A&s';

  final _phoneController = TextEditingController();
  File? _selectImage;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phone;
  }

  void _updatUser() async {
    try {
      setState(() {
        isUploading = true;
      });
      await FirebaseFirestore.instance
          .collection('all_users_information')
          .doc(widget.userId)
          .collection('info')
          .doc(widget.userId)
          .set({
        'Phone': _phoneController.text.trim(),
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        'Phone': _phoneController.text.trim(),
      }, SetOptions(merge: true));

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succeeded'),
            content: const Text('Data has been updated'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    isUploading = false;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isUploading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.message ?? 'Authentication failed'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    isUploading = false;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleAppBar(title: 'Update Profile'),
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
              padding: EdgeInsets.all(15.0.w),
              child: Center(
                  child: Column(
                children: [
                  UserImagePickerGalary(
                    onPickImage: (File pickedImage) {
                      _selectImage = pickedImage;
                    },
                    imageCase: imagepersonal,
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number:',
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
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  if (isUploading)
                    const CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  if (!isUploading)
                    SizedBox(
                      width: 300.w,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _updatUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.w),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

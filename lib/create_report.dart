// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/style/appBar.dart';
import 'package:cse/style/background.dart';
import 'package:cse/user_image_camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({Key? key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  String imagepersonal =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShB7IwN9gr4q2Tn-1CRfbgANRN-8SWlYMMy9iq467T1A&s';

  final _notesController = TextEditingController();

  File? _selectImage;
  String? accident;
  bool isUploading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void send() async {
    Position position = await Geolocator.getCurrentPosition();

    if (accident != null) {
      try {
        setState(() {
          isUploading = true;
        });

        final DocumentReference documentReference =
            await _firestore.collection('Reports').add(
          {
            'reportsId': '',
            'userId': FirebaseAuth.instance.currentUser!.uid,
            'Notes': _notesController.text.trim(),
            'latitude': position.latitude,
            'longitude': position.longitude,
            'email': FirebaseAuth.instance.currentUser!.email,
            'type_accident': accident,
          },
        );
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('report_image')
            .child('${documentReference.id}.jpg');

        await storageRef.putFile(_selectImage!);

        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Reports')
            .doc(documentReference.id)
            .set({
          'reportImage': imageUrl,
        }, SetOptions(merge: true));

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Report added successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          isUploading = false;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          isUploading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(e.message ?? 'Verification failed'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No value selected'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
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
      appBar: StyleAppBar(title: 'Create Report'),
      body: BackgroundColor(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                //لون الخط
                color: Color.fromARGB(255, 81, 0, 0),
                // عرض الخط
                thickness: 3.0,
              ),
              Padding(
                padding: EdgeInsets.all(15.w),
                child: Column(
                  children: [
                    UserImagePickerCamera(
                      onPickImage: (File pickedImage) {
                        _selectImage = pickedImage;
                      },
                      imageCase: imagepersonal,
                    ),
                    SizedBox(height: 25.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Type Accident:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        DropdownButtonFormField<String>(
                          value: accident,
                          items: _type.map((String accident) {
                            return DropdownMenuItem<String>(
                              value: accident,
                              child: Text(
                                accident,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              accident = newValue;
                            });
                          },
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                            hintText: 'Select Type Accident',
                            fillColor: Colors.grey[100],
                            filled: true,
                            alignLabelWithHint: true,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0.w,
                              ),
                              borderRadius: BorderRadius.circular(10.0.w),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0.w,
                              horizontal: 20.h,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.5.w,
                              ),
                              borderRadius: BorderRadius.circular(10.0.w),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notes:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextFormField(
                          maxLines: 3,
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
                          autocorrect: true,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          controller: _notesController,
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
                        width: 200.w,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: send,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.w),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Send Reports',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> _type = [
    'Fire',
    'Flood',
    'Earthquake',
    'Electricity contact',
    'Sinking',
    'Other',
  ];
}

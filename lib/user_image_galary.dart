// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePickerGalary extends StatefulWidget {
  const UserImagePickerGalary(
      {super.key, required this.onPickImage, required this.imageCase});

  final void Function(File pickedImage) onPickImage;
  final String imageCase;
  @override
  State<UserImagePickerGalary> createState() => _UserImagePickerGalaryState();
}

class _UserImagePickerGalaryState extends State<UserImagePickerGalary> {
  File? _pickImageFile;
  bool isUploading = false;

  void _pickImageGalary() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
    );
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickImageFile = File(pickedImage.path);
    });
    widget.onPickImage(_pickImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 52.w,
          backgroundColor: Colors.black,
          foregroundImage: _pickImageFile == null
              ? NetworkImage(widget.imageCase)
              : FileImage(File(_pickImageFile!.path)) as ImageProvider<Object>?,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUploading)
              const CircularProgressIndicator(
                color: Colors.black,
              ),
            if (!isUploading)
              SizedBox(
                width: 250.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _pickImageGalary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.w),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Upload Image',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

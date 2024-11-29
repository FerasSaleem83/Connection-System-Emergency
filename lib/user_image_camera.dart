import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePickerCamera extends StatefulWidget {
  const UserImagePickerCamera(
      {Key? key, required this.onPickImage, required this.imageCase})
      : super(key: key);

  final void Function(File pickedImage) onPickImage;
  final String imageCase;
  @override
  State<UserImagePickerCamera> createState() => _UserImagePickerCameraState();
}

class _UserImagePickerCameraState extends State<UserImagePickerCamera> {
  File? _pickImageFile;
  bool isUploading = false;

  void _pickImageCamera() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
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
        SizedBox(height: 25.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 200.w,
            height: 200.h,
            color: Colors.black,
            child: _pickImageFile == null
                ? Image.network(
                    widget.imageCase,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(_pickImageFile!.path),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(height: 25.h),
        if (isUploading)
          const CircularProgressIndicator(
            color: Colors.black,
          ),
        if (!isUploading)
          SizedBox(
            width: 250.w,
            height: 50.h,
            child: ElevatedButton(
              onPressed: _pickImageCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.w),
                  ),
                ),
              ),
              child: const Text(
                'Pick Image From Camera',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/splash_screen.dart';
import 'package:cse/style/appbar.dart';
import 'package:cse/style/background.dart';
import 'package:cse/style/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarAvilable extends StatefulWidget {
  final String userId;
  final String typeAccident;
  final double latitude;
  final double longitude;
  final String reportId;
  const CarAvilable(
      {required this.userId,
      required this.typeAccident,
      required this.latitude,
      required this.longitude,
      required this.reportId,
      super.key});

  @override
  State<CarAvilable> createState() => _CarAvilableState();
}

class _CarAvilableState extends State<CarAvilable> {
  late Stream<List<DocumentSnapshot>> reportStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    _uploadData();
  }

  _uploadData() {
    reportStream = FirebaseFirestore.instance
        .collection('drivers')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // وضع شريط علوي للصفحة
      appBar: StyleAppBar(title: 'CSE'),
      drawer: const MyDrawer(),

      // وضع الخصائص للصفحة
      body: BackgroundColor(
        // انشاء صف
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: reportStream,
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
              List<DocumentSnapshot> reports = snapshot.data!;
              return Padding(
                padding: EdgeInsets.all(5.w),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // عدد الأعمدة
                    mainAxisSpacing: 1.h, // المسافة العمودية بين الصفوف
                    childAspectRatio: 2,
                    mainAxisExtent: 170.h,
                  ),
                  itemCount: (reports.length / 1).ceil(), // عدد الصفوف
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: reports
                          .sublist(
                        index * 1,
                        (index * 1) + 1 > reports.length
                            ? reports.length
                            : (index * 1) + 1,
                      )
                          .map(
                        (report) {
                          String driverId = report['ID'];
                          String name = report['Name'];
                          double latitude = report['latitude'];
                          double longitude = report['longitude'];
                          String avilable = report['avilable'];
                          String phone = report['Phone'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 350.w,
                                child: const Divider(
                                  //لون الخط
                                  color: Color.fromARGB(255, 81, 0, 0),
                                  // عرض الخط
                                  thickness: 3.0,
                                ),
                              ),
                              buildInfoColumn(
                                name,
                                latitude,
                                longitude,
                                avilable,
                                isUploading,
                                () async {
                                  setState(() {
                                    isUploading == true;
                                  });
                                  final DocumentReference documentReference =
                                      await _firestore
                                          .collection('AssignReport')
                                          .add(
                                    {
                                      'userId': widget.userId,
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'driverId': driverId,
                                      'driverName': name,
                                      'driverPhone': phone,
                                      'typeAccident': widget.typeAccident,
                                      'latitudeAccident': widget.latitude,
                                      'longitudeAccident': widget.longitude,
                                      'reportsId': widget.reportId,
                                      'assignreportsId': ''
                                    },
                                  );
                                  DocumentReference placeReference =
                                      FirebaseFirestore.instance
                                          .collection('AssignReport')
                                          .doc(documentReference.id);

                                  await placeReference.set({
                                    'assignreportsId': documentReference.id,
                                  }, SetOptions(merge: true));
                                  await _firestore
                                      .collection('drivers')
                                      .doc(driverId)
                                      .set({
                                    'avilable': 'Not Avilable',
                                  }, SetOptions(merge: true));
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: const Text(
                                            'Assign Report Successfully'),
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
                                    isUploading == false;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

//  بناء صف جديد function
Widget buildInfoColumn(
    /*لاضافة قيمة العنوان عند استداء الفنكشن ويكون نوعه نص */
    String title,
    /*لاضافة امتداد(مكان وجودها) الصورة عند استداء الفنكشن ويكون نوعه نص */
    double latitude,
    double longitude,
    String avilable,
    bool isUploading,
    /*لاضافة فنكشن يقوم بوظيفة محددة مثل فتح صفحة الوصف */
    Function() assignReport) {
  // لوضع لون لخلفية كل صف
  return Column(
    children: [
      Container(
        // لون خلفية الصف أبيض
        color: const Color.fromARGB(255, 240, 240, 240),
        // اخذ مسافة على الاطراف
        child: Padding(
          // مقدار المسافة على الاطراف 15 وحدة القياس تكون (بكسل)
          padding: EdgeInsets.all(5.w),
          // انشاء صفوف
          child: Column(
            children: [
              // انشاء اعمدة
              SizedBox(
                width: 320.w,
                child: Row(
                  children: [
                    // اضافة صورة
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/originals/bd/0a/34/bd0a34b9ecce39f5c35064a8d5cd0f33.jpg'),
                      radius: 40.w,
                      backgroundColor: Color.fromARGB(255, 20, 1, 119),
                    ),
                    SizedBox(width: 25.w), // وضع مساف بين الاعمدة بقيمة 25 بكسل
                    // لجعل الصف كصندوق ممكن تحديد العرض والطول فيه
                    SizedBox(
                      width: 200.w, // العرض
                      //انشاء صف
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // انشاء نص
                          Text(
                            'Name: $title', // يتم تحديد النص الذي سوف يكتب عند استدعاء الفنكشن
                            // وضع النص في نهاية الصف
                            textAlign: TextAlign.start,
                            // اضافة خصائص للنص
                            style: TextStyle(
                              //جعل النص باللون الغامق
                              fontWeight: FontWeight.bold,
                              // جعل النص بحجم 15 بكسل
                              fontSize: 15.sp,
                            ),
                          ),
                          // انشاء نص
                          Text(
                            // وضع النص في نهاية الصف
                            'latitude: $latitude',
                            // وضع النص في نهاية الصف
                            textAlign: TextAlign.start,
                            // اضافة خصائص للنص
                            style: TextStyle(
                              //جعل النص باللون الغامق
                              fontWeight: FontWeight.bold,
                              // جعل النص بحجم 15 بكسل
                              fontSize: 15.sp,
                            ),
                          ),
                          // انشاء نص
                          Text(
                            // وضع النص في نهاية الصف
                            'longitude: $longitude',
                            // وضع النص في نهاية الصف
                            textAlign: TextAlign.start,
                            // اضافة خصائص للنص
                            style: TextStyle(
                              //جعل النص باللون الغامق
                              fontWeight: FontWeight.bold,
                              // جعل النص بحجم 15 بكسل
                              fontSize: 15.sp,
                            ),
                          ),
                          if (isUploading)
                            const CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          if (!isUploading)
                            if (avilable == 'avilable')
                              // انشاء صندوق لتحديد الحجم
                              SizedBox(
                                // يكون عرض الصندوق يساوي عرض الصف
                                width: 175.w,
                                // انشاء كبسة للضغط عليها
                                child: ElevatedButton(
                                  // عند الضغط عليها سوف يتم الذهاب الى صفحة الوصف
                                  onPressed: assignReport,
                                  // لاضافة خصائص للكبسة
                                  style: ElevatedButton.styleFrom(
                                      // جعل لون خلفية الكبسة سكني فاتح
                                      backgroundColor: const Color.fromARGB(
                                          255, 213, 211, 211),
                                      // جعل لون النص الموجود داخل الكبسة باللون الأسود
                                      foregroundColor: Colors.black),
                                  // النص الموجود في الكبسة
                                  child: const Text('ASSIGN REPORT'),
                                ),
                              ),
                          if (avilable != 'avilable')
                            Text(
                              // وضع النص في نهاية الصف
                              'Not Avilable',
                              // وضع النص في نهاية الصف
                              textAlign: TextAlign.start,
                              // اضافة خصائص للنص
                              style: TextStyle(
                                //جعل النص باللون الغامق
                                fontWeight: FontWeight.bold,
                                // جعل النص بحجم 15 بكسل
                                fontSize: 15.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // وضع خط تحت الصف
            ],
          ),
        ),
      ),
      SizedBox(
        width: 350.w,
        child: Divider(
          //لون الخط
          color: Color.fromARGB(255, 81, 0, 0),
          // عرض الخط
          thickness: 3.0,
        ),
      ),
    ],
  );
}

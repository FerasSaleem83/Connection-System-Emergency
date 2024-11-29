// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/splash_screen.dart';
import 'package:cse/style/appbar.dart';
import 'package:cse/style/background.dart';
import 'package:cse/style/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
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
        .collection('AssignReport')
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
                        (assignreport) {
                          String driverId = assignreport['driverId'];
                          String typeAccident = assignreport['typeAccident'];
                          double latitude = assignreport['latitudeAccident'];
                          double longitude = assignreport['longitudeAccident'];
                          String reportId = assignreport['reportsId'];
                          String assignreportId =
                              assignreport['assignreportsId'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildInfoColumn(
                                typeAccident,
                                latitude,
                                longitude,
                                isUploading,
                                () async {
                                  await _launchGPSNavigation(
                                      latitude, longitude);
                                },
                                () async {
                                  setState(() {
                                    isUploading == true;
                                  });
                                  await _firestore
                                      .collection('drivers')
                                      .doc(driverId)
                                      .set({
                                    'avilable': 'avilable',
                                  }, SetOptions(merge: true));

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: const Text(
                                            'Finish Mission Successfully'),
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
                                  await FirebaseFirestore.instance
                                      .collection('AssignReport')
                                      .doc(assignreportId)
                                      .delete();
                                  await FirebaseFirestore.instance
                                      .collection('Reports')
                                      .doc(reportId)
                                      .delete();
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

  _launchGPSNavigation(double latitude, double longitude) async {
    String url = 'https://www.google.com/maps/search/$latitude,$longitude';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

//  بناء صف جديد function
Widget buildInfoColumn(
    /*لاضافة قيمة العنوان عند استداء الفنكشن ويكون نوعه نص */
    String title,
    /*لاضافة امتداد(مكان وجودها) الصورة عند استداء الفنكشن ويكون نوعه نص */
    double latitude,
    double longitude,
    bool isUploading,
    /*لاضافة فنكشن يقوم بوظيفة محددة مثل فتح صفحة الوصف */
    Function() getdirection,
    /*لاضافة فنكشن يقوم بوظيفة محددة مثل فتح صفحة الوصف */
    Function() finishmission) {
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
                      backgroundImage: const NetworkImage(
                          'https://www.computerhope.com/jargon/l/list.jpg'),
                      radius: 40.r,
                      backgroundColor: const Color.fromARGB(255, 20, 1, 119),
                    ),
                    SizedBox(width: 25.w), // وضع مساف بين الاعمدة بقيمة 25 بكسل
                    // لجعل الصف كصندوق ممكن تحديد العرض والطول فيه
                    SizedBox(
                      width: 175.w, // العرض
                      //انشاء صف
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // انشاء نص
                          Text(
                            title, // يتم تحديد النص الذي سوف يكتب عند استدعاء الفنكشن
                            // وضع النص في نهاية الصف
                            textAlign: TextAlign.start,
                            // اضافة خصائص للنص
                            style: TextStyle(
                              //جعل النص باللون الغامق
                              fontWeight: FontWeight.bold,
                              // جعل النص بحجم 15 بكسل
                              fontSize: 18.sp,
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
                            // انشاء صندوق لتحديد الحجم
                            SizedBox(
                              // يكون عرض الصندوق يساوي عرض الصف
                              width: 175.w,
                              // انشاء كبسة للضغط عليها
                              child: ElevatedButton(
                                // عند الضغط عليها سوف يتم الذهاب الى صفحة الوصف
                                onPressed: getdirection,
                                // لاضافة خصائص للكبسة
                                style: ElevatedButton.styleFrom(
                                    // جعل لون خلفية الكبسة سكني فاتح
                                    backgroundColor: const Color.fromARGB(
                                        255, 213, 211, 211),
                                    // جعل لون النص الموجود داخل الكبسة باللون الأسود
                                    foregroundColor: Colors.black),
                                // النص الموجود في الكبسة
                                child: const Text('GET DIRECTIONS'),
                              ),
                            ),
                          if (isUploading)
                            const CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          if (!isUploading)
                            // انشاء صندوق لتحديد الحجم
                            SizedBox(
                              // يكون عرض الصندوق يساوي عرض الصف
                              width: 175.w,
                              // انشاء كبسة للضغط عليها
                              child: ElevatedButton(
                                // عند الضغط عليها سوف يتم الذهاب الى صفحة الوصف
                                onPressed: finishmission,
                                // لاضافة خصائص للكبسة
                                style: ElevatedButton.styleFrom(
                                    // جعل لون خلفية الكبسة سكني فاتح
                                    backgroundColor: const Color.fromARGB(
                                        255, 213, 211, 211),
                                    // جعل لون النص الموجود داخل الكبسة باللون الأسود
                                    foregroundColor: Colors.black),
                                // النص الموجود في الكبسة
                                child: const Text('FINISH MISSION'),
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
        child: const Divider(
          //لون الخط
          color: Color.fromARGB(255, 81, 0, 0),
          // عرض الخط
          thickness: 3.0,
        ),
      ),
    ],
  );
}

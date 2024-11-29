import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/car_avilable.dart';
import 'package:cse/style/appBar.dart';
import 'package:cse/style/background.dart';
import 'package:cse/style/drawer.dart';
import 'package:cse/splash_screen.dart';
import 'package:cse/style/full_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Stream<List<DocumentSnapshot>> reportStream;
  @override
  void initState() {
    super.initState();
    _uploadData();
  }

  _uploadData() {
    reportStream = FirebaseFirestore.instance
        .collection('Reports')
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
                          String userId = report['userId'];
                          String typeAccident = report['type_accident'];
                          double latitude = report['latitude'];
                          double longitude = report['longitude'];
                          String reportId = report['reportsId'];
                          String imageUrl = report['reportImage'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildInfoColumn(
                                typeAccident,
                                latitude,
                                longitude,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarAvilable(
                                        userId: userId,
                                        typeAccident: typeAccident,
                                        latitude: latitude,
                                        longitude: longitude,
                                        reportId: reportId,
                                      ),
                                    ),
                                  );
                                },
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullScreenImage(
                                            imageUrl: imageUrl)),
                                  );
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
  /*لاضافة فنكشن يقوم بوظيفة محددة مثل فتح صفحة الوصف */
  Function() movecar,
  Function() image,
) {
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
                      width: 200.w, // العرض
                      //انشاء صف
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // انشاء نص
                          Row(
                            children: [
                              Text(
                                title, // يتم تحديد النص الذي سوف يكتب عند استدعاء الفنكشن
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
                              IconButton(
                                onPressed: image,
                                icon: const Icon(
                                  Icons.photo,
                                ),
                              )
                            ],
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

                          // انشاء صندوق لتحديد الحجم
                          SizedBox(
                            // يكون عرض الصندوق يساوي عرض الصف
                            width: 175.w,
                            // انشاء كبسة للضغط عليها
                            child: ElevatedButton(
                              // عند الضغط عليها سوف يتم الذهاب الى صفحة الوصف
                              onPressed: movecar,
                              // لاضافة خصائص للكبسة
                              style: ElevatedButton.styleFrom(
                                  // جعل لون خلفية الكبسة سكني فاتح
                                  backgroundColor:
                                      const Color.fromARGB(255, 213, 211, 211),
                                  // جعل لون النص الموجود داخل الكبسة باللون الأسود
                                  foregroundColor: Colors.black),
                              // النص الموجود في الكبسة
                              child: const Text('MOVE A CAR'),
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

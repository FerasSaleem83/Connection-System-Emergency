// ignore_for_file: deprecated_member_use

import 'package:cse/breath.dart';
import 'package:cse/fainting.dart';
import 'package:cse/style/appBar.dart';
import 'package:cse/style/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstAidsPage extends StatelessWidget {
  const FirstAidsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // وضع شريط علوي للصفحة
      appBar: StyleAppBar(title: 'CSE'),
      // وضع الخصائص للصفحة
      body: BackgroundColor(
        // تغيير لون خلفية الصفحة

        // انشاء صف
        child: Column(
          // وضع العناصر التي داخل الصف في بداية الصف
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // وضع خط تحت الصف
            const Divider(
              //لون الخط
              color: Color.fromARGB(255, 81, 0, 0),
              // عرض الخط
              thickness: 3.0,
            ),
            // استدعاء فنكشن وادخال القيم بداخله
            buildInfoColumn(
              "ضيق تنفس", // العنوان
              "ضيق النفس المفاجئ عند الانسان", // الوصف
              'assets/images/breath.jpeg', // امتداد الصورة
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Breath(),
                  ),
                );
              }, // الصفحة التي سوف ننقل اليها عند النقر على الكبسة
            ),
            // وضع خط تحت الصف
            const Divider(
              //لون الخط
              color: Color.fromARGB(255, 81, 0, 0),
              // عرض الخط
              thickness: 3.0,
            ),
            // استدعاء فنكشن وادخال القيم بداخله
            buildInfoColumn(
              "إغماء", // العنوان
              "فقدان الوعي المفاجئ عند الانسان", // الوصف
              'assets/images/fainting.png', // امتداد الصورة
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Fainting(),
                  ),
                );
              }, // الصفحة التي سوف ننقل اليها عند النقر على الكبسة
            ),
            // وضع خط تحت الصف
            const Divider(
              //لون الخط
              color: Color.fromARGB(255, 81, 0, 0),
              // عرض الخط
              thickness: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}

//  بناء صف جديد function
Widget buildInfoColumn(
    /*لاضافة قيمة العنوان عند استداء الفنكشن ويكون نوعه نص */
    String title,
    /*لاضافة قيمة الوصف عند استداء الفنكشن ويكون نوعه نص */
    String details,
    /*لاضافة امتداد(مكان وجودها) الصورة عند استداء الفنكشن ويكون نوعه نص */
    String image,
    /*لاضافة فنكشن يقوم بوظيفة محددة مثل فتح صفحة الوصف */
    Function() getDetails) {
  // لوضع لون لخلفية كل صف
  return Container(
    // لون خلفية الصف أبيض
    color: Colors.white,
    // اخذ مسافة على الاطراف
    child: Padding(
      // مقدار المسافة على الاطراف 15 وحدة القياس تكون (بكسل)
      padding: EdgeInsets.all(15.w),
      // انشاء صفوف
      child: Column(
        children: [
          // انشاء اعمدة
          Row(
            children: [
              // اضافة صورة
              Image.asset(
                image, // امتداد الصورة (مكان وجودها)
                width: 100.w, // عرض الصورة
                height: 100.h, // ارتفاع الصورة
              ),
              SizedBox(width: 25.w), // وضع مساف بين الاعمدة بقيمة 25 بكسل
              // لجعل الصف كصندوق ممكن تحديد العرض والطول فيه
              SizedBox(
                width: 190.w, // العرض
                //انشاء صف
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // انشاء نص
                    Text(
                      title, // يتم تحديد النص الذي سوف يكتب عند استدعاء الفنكشن
                      // وضع النص في نهاية الصف
                      textAlign: TextAlign.end,
                      // اضافة خصائص للنص
                      style: TextStyle(
                        //جعل النص باللون الغامق
                        fontWeight: FontWeight.bold,
                        // جعل النص بحجم 18 بكسل
                        fontSize: 18.sp,
                      ),
                    ),
                    // انشاء نص
                    Text(
                      // وضع النص في نهاية الصف
                      details,
                      // وضع النص في نهاية الصف
                      textAlign: TextAlign.end,
                      // اضافة خصائص للنص
                      style: TextStyle(
                        //جعل النص باللون الغامق
                        fontWeight: FontWeight.bold,
                        // جعل النص بحجم 18 بكسل
                        fontSize: 18.sp,
                      ),
                    ),
                    // انشاء صندوق لتحديد الحجم
                    SizedBox(
                      // يكون عرض الصندوق يساوي عرض الصف
                      width: double.maxFinite,
                      // انشاء كبسة للضغط عليها
                      child: ElevatedButton(
                        // عند الضغط عليها سوف يتم الذهاب الى صفحة الوصف
                        onPressed: getDetails,
                        // لاضافة خصائص للكبسة
                        style: ElevatedButton.styleFrom(
                            // جعل لون خلفية الكبسة سكني فاتح
                            backgroundColor:
                                const Color.fromARGB(255, 213, 211, 211),
                            // جعل لون النص الموجود داخل الكبسة باللون الأسود
                            foregroundColor: Colors.black),
                        // النص الموجود في الكبسة
                        child: const Text('GET DETAILS'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

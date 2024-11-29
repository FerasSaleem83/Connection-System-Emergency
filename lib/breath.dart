import 'package:cse/style/appbar.dart';
import 'package:cse/style/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Breath extends StatelessWidget {
  const Breath({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleAppBar(title: 'CSE'),
      body: BackgroundColor(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Divider(
                    //لون الخط
                    color: Color.fromARGB(255, 81, 0, 0),
                    // عرض الخط
                    thickness: 3.0,
                  ),
                  Text(
                    'ضيق النفس المفاجئ عند الانسان',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  // اضافة صورة
                  Image.asset(
                    'assets/images/breath.jpeg', // امتداد الصورة (مكان وجودها)
                    width: 250.w, // عرض الصورة
                    height: 250.h, // ارتفاع الصورة
                  ),
                  SizedBox(height: 25.h), // وضع مساف بين الصفوف بقيمة 25 بكسل
                  Text(
                    'اضرب خمس ضربات على الظهر. قف جانبًا وراء الشخص المختنق مباشرة. وإن كان طفلاً، فاجثُ على ركبتيك خلفه. ضع ذراعك على صدر الشخص لدعم جسمه. اثنِ جسم الشخص من عند الخصر ليكون مواجهًا للأرض. اضرب خمس ضربات منفصلة بين لوحي كتف الشخص باستخدام أسفل راحة يدك.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 10.h),

                  Text(
                    'اضغط خمس ضغطات على البطن. إذا لم تؤدّ ضربات الظهر إلى إزالة الجسم العالق، فاضغط خمس ضغطات على البطن، وهو ما يُعرف أيضًا بمناورة هايمليش.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'بدّل بين الضربات الخمسة والضغطات الخمسة حتى يزول الانسداد.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
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

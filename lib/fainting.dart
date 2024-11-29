import 'package:cse/style/appbar.dart';
import 'package:cse/style/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Fainting extends StatelessWidget {
  const Fainting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleAppBar(title: 'CSE'),
      body: BackgroundColor(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                children: [
                  const Divider(
                    //لون الخط
                    color: Color.fromARGB(255, 81, 0, 0),
                    // عرض الخط
                    thickness: 3.0,
                  ),
                  Text(
                    'فقدان الوعي المفاجئ عند الانسان',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  // اضافة صورة
                  Image.asset(
                    'assets/images/fainting.png', // امتداد الصورة (مكان وجودها)
                    width: 250.w, // عرض الصورة
                    height: 250.h, // ارتفاع الصورة
                  ),
                  SizedBox(height: 25.h), // وضع مساف بين الصفوف بقيمة 25 بكسل

                  Text(
                    'فاجعله يستلقي على ظهره. إذا لم تكن هناك إصابات وكان الشخص يتنفس، فارفع ساقيه فوق مستوى القلب إن أمكن. وارفع ساقيه حوالي 12 بوصة (30 سنتيمترًا). فك الحزام أو زر الياقة أو أي ملابس ضيقة.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'تحقق من أنه يتنفس. تحسس النبض للتحقق مما إذا كان الشخص يتنفس. إذا لم يكن الشخص يتنفس، فابدأ بإجراء الإنعاش القلبي الرئوي. اتصل على الرقم 911 أو رقم الطوارئ في منطقتك. استمر في إجراء الإنعاش القلبي الرئوي حتى تصل المساعدة أو يستعيد الشخص التنفس.',
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

// ignore_for_file: deprecated_member_use

import 'package:cse/style/appBar.dart';
import 'package:cse/style/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNumbers extends StatelessWidget {
  const EmergencyNumbers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleAppBar(title: 'CSE'),
      body: BackgroundColor(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                color: Color.fromARGB(255, 81, 0, 0),
                thickness: 3.0,
              ),
              buildInfoColumn(
                'طوارئ الأمن العام والدفاع المدني والدرك',
                '911',
                'assets/images/emergency.png',
                () {
                  _launchPhone('911');
                },
              ),
              const Divider(
                color: Color.fromARGB(255, 81, 0, 0),
                thickness: 3.0,
              ),
              buildInfoColumn(
                'للإستشارات الطبية"إسأل عن الكورونا"',
                '111',
                'assets/images/corona.png',
                () {
                  _launchPhone('111');
                },
              ),
              const Divider(
                color: Color.fromARGB(255, 81, 0, 0),
                thickness: 3.0,
              ),
              buildInfoColumn(
                'شكاوي تتعلق بالمشتقات النفطية والكهرباء',
                '065805025',
                'assets/images/electricity.png',
                () {
                  _launchPhone('065805025');
                },
              ),
              const Divider(
                color: Color.fromARGB(255, 81, 0, 0),
                thickness: 3.0,
              ),
              buildInfoColumn(
                'وزارة المياه والري',
                '065671017',
                'assets/images/water.png',
                () {
                  _launchPhone('065671017');
                },
              ),
              const Divider(
                color: Color.fromARGB(255, 81, 0, 0),
                thickness: 3.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// بناء صف جديد
Widget buildInfoColumn(
    String title, String details, String image, Function() getDetails) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                image,
                width: 100.w,
                height: 100.h,
              ),
              SizedBox(width: 25.w),
              SizedBox(
                width: 200.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      details,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: getDetails,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 213, 211, 211),
                            foregroundColor: Colors.black),
                        child: const Text('CALL NOW'),
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

_launchPhone(String phoneNumber) async {
  final url = "tel:$phoneNumber";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

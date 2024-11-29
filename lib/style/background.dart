import 'package:flutter/material.dart';

class BackgroundColor extends StatelessWidget {
  final Widget child;

  const BackgroundColor({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final int currentHour = currentTime.hour;

    final gradient = currentHour >= 6 && currentHour < 18
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // النهار
              Color.fromARGB(255, 255, 255, 255),
              Colors.white,
              Color.fromARGB(255, 89, 172, 250),
              Color.fromARGB(255, 89, 173, 236),
            ],
          )
        // الليل
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Color.fromARGB(255, 1, 39, 100),
              Color.fromARGB(255, 1, 39, 68),
            ],
          );

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: child,
    );
  }
}

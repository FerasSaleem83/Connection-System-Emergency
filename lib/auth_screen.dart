import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse/check_account.dart';
import 'package:cse/login.dart';
import 'package:cse/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> futureBuilder;

  @override
  void initState() {
    super.initState();
    futureBuilder = getUsers();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUsers() async {
    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('all_users_information')
            .doc(userId)
            .collection('info')
            .doc(userId) // Use where here
            .get();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: futureBuilder,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  } else if (snapshot.hasError) {
                    return const SplashScreen();
                  } else if (snapshot.hasData) {
                    final userType = snapshot.data!['type'];
                    final name = snapshot.data!['Name'];
                    return CheckAccount(username: name, userType: userType);
                  } else {
                    return const SplashScreen();
                  }
                },
              ),
            );
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}

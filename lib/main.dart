// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice/pages/inventory.dart';
import 'package:practice/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyB28sX0FJlxzciWr5WTq9qpyeHWBrb34UM',
      appId: '1:662546318811:android:e9b7673fe484cf13c953fe',
      messagingSenderId: '662546318811',
      projectId: 'sample-cf991',
      storageBucket: 'sample-cf991.appspot.com',
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
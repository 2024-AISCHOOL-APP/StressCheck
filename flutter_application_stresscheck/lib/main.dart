import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/result.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'app screen/first.dart';
import 'app_screen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResultPage(),
    );
  }
}


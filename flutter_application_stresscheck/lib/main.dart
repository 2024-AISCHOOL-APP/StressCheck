import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/auth_provider.dart';
import 'package:flutter_application_stresscheck/app_screen/result.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
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


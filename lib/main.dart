import 'package:flutter/material.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/screens/login_screens.dart';
import 'package:sri_mahalakshmi/splash_screen.dart';

import 'core/utility/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColor.ScaffoldColor),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

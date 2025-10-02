import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/screens/login_screens.dart';
import 'package:sri_mahalakshmi/splash_screen.dart';

import 'core/utility/app_colors.dart';
import 'init_controller.dart';

Future<void> main() async {
  await initController();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColor.ScaffoldColor),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

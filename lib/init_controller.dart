import 'package:get/get.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/controllers/login_controller.dart';
import 'package:sri_mahalakshmi/presentation/Home/controller/home_controller.dart';
import 'package:sri_mahalakshmi/presentation/Join_schemes/controller/scheme_controller.dart';


Future<void>  initController() async {
  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => SchemeController());


}
import 'package:get/get.dart';
import 'package:sri_mahalakshmi/presentation/Authentication/controllers/login_controller.dart';


Future<void>  initController() async {
  Get.lazyPut(() => LoginController());


}
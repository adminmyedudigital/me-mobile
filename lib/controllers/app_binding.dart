import 'package:get/get.dart';
import 'package:me_mobile/controllers/controllers.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController(), permanent: true);
    Get.lazyPut(AnalyticsController.new, fenix: true);
    Get.lazyPut(HomeController.new, fenix: true);
    Get.lazyPut(DashboardController.new, fenix: true);
    Get.lazyPut(ExamsController.new, fenix: true);
  }
}

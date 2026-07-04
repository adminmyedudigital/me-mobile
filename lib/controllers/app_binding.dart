import 'package:get/get.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/controllers.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService()..init(), permanent: true);
    Get.put(AppController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(AnalyticsController.new, fenix: true);
    Get.lazyPut(HomeController.new, fenix: true);
    Get.lazyPut(DashboardController.new, fenix: true);
    Get.lazyPut(ExamsController.new, fenix: true);
    Get.lazyPut(FlashCardController.new, fenix: true);
    Get.lazyPut(QuizController.new, fenix: true);
    Get.lazyPut(ScheduleTimetableController.new, fenix: true);
  }
}

import 'package:get/get.dart';

import 'package:me_mobile/services/services.dart';

mixin ApiControllerMixin on GetxController {
  ApiService get api => Get.find<ApiService>();
}

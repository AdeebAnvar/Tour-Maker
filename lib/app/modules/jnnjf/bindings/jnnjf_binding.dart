import 'package:get/get.dart';

import '../controllers/jnnjf_controller.dart';

class JnnjfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JnnjfController>(
      () => JnnjfController(),
    );
  }
}

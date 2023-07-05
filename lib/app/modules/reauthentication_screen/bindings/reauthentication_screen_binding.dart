import 'package:get/get.dart';

import '../controllers/reauthentication_screen_controller.dart';

class ReauthenticationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReauthenticationScreenController>(
      () => ReauthenticationScreenController(),
    );
  }
}

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_dialogue.dart';

class NointernetController extends GetxController {
  Rx<bool> isLoading = false.obs;

  Future<void> checkConnection() async {
    isLoading.value = true;
    if (await InternetConnectionChecker().hasConnection == true) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      isLoading.value = false;
    } else {
      CustomDialog().showCustomDialog('Connection Error !',
          contentText: 'Please check your Wifi/Data');

      isLoading.value = false;
    }
  }
}

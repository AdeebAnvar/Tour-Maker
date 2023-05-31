import 'package:get/get.dart';

import '../controllers/suggest_friend_controller.dart';

class SuggestFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuggestFriendController>(
      () => SuggestFriendController(),
    );
  }
}

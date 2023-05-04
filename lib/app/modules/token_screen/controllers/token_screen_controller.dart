import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TokenScreenController extends GetxController
    with StateMixin<dynamic>, GetSingleTickerProviderStateMixin {
  String? tok;
  String? fcmtok;
  late TabController tabController;

  GetStorage getstorage = GetStorage();
  @override
  void onInit() {
    super.onInit();
    loadData();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      tok = Get.arguments[0] as String;
      fcmtok = Get.arguments[1] as String;
      await getstorage.write('fcmtok', fcmtok);
      change(null, status: RxStatus.success());
    } else {
      tok = getstorage.read('token');
      fcmtok = getstorage.read('fcmtok');
    }
  }
}

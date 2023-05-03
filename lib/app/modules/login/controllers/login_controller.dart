import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';

class LoginController extends GetxController with StateMixin<dynamic> {
  GlobalKey<FormState> formKey = GlobalKey();
  UserRepository userRepo = UserRepository();
  late List<String> states = userRepo.getStates();
  final GetStorage getStorage = GetStorage();
  @override
  RxString state = ''.obs;
  RxString name = ''.obs;
  RxString phone = ''.obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    loadUserCredentials();
    state.value = states[0];
  }

  String? usernameValidator(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 4) ? 'Please enter your name' : null;

  Future<void> onClickContinue(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      if (state.value == states[0]) {
        Get.snackbar('Select your district', 'please select your country');
      }
      final UserModel user = UserModel(
        name: name.value,
        phoneNumber: phone.value,
        state: state.value,
        category: 'standard',
      );
      await getStorage.write('currentUserCategory', 'standard');
      await getStorage.write('currentUserName', name.value);
      await getStorage.write('currentUserState', user.state);
      await getStorage.write('initialPayment', '');
      // currentUserName = name.value;
      // // currentUserState = state.value;
      // currentUserCategory = 'standard';
      final ApiResponse<Map<String, dynamic>> res =
          await userRepo.loginTheUser(user);
      if (res.status == ApiResponseStatus.completed) {
        log('completed');

        Get.offAllNamed(Routes.TERMS_AND_CONDITIONS);
        isLoading.value = false;
      } else {
        log('sdfgsg');
      }
    }
  }

  void loadUserCredentials() {
    if (Get.arguments != null) {
      phone.value = Get.arguments as String;
    }
  }
}

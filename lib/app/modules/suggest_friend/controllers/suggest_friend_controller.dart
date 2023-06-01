import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/network_models/suggest_a_friend.dart';
import '../../../data/repo/network_repo/suggest_a_friend_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';

class SuggestFriendController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey();
  Rx<String> name = ''.obs;
  Rx<String> state = ''.obs;
  Rx<String> phone = ''.obs;
  Rx<String> district = ''.obs;
  Rx<String> address = ''.obs;
  RxString country = ''.obs;
  RxBool isloading = false.obs;
  GetStorage getStorage = GetStorage();
  String? nameValidator(String? value) => GetUtils.isLengthLessOrEqual(value, 3)
      ? 'Please enter a valid name'
      : null;

  String? phoneNumberValidator(String? value) =>
      GetUtils.isLengthEqualTo(value, 10)
          ? null
          : 'Please add a valid phone number (without country code)';

  String? addressValidator(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 10)
          ? 'Please add valid address'
          : null;

  String? stateValidator(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 3)
          ? 'Please enter a valid state'
          : null;

  String? districtValidator(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 3)
          ? 'Please enter a valid district'
          : null;

  String? countryValidator(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 3)
          ? 'Please enter a valid country'
          : null;

  Future<void> onRegisterClicked() async {
    isloading.value = true;
    if (formKey.currentState!.validate()) {
      final ReferAFriend referAFriendModel = ReferAFriend(
        referralAddress: address.value,
        referralContact: phone.value,
        referralCountry: country.value,
        referralDistrict: district.value,
        referralName: name.value,
        referralState: state.value,
      );

      try {
        final ApiResponse<Map<String, dynamic>> res = await SuggestAFriendRepo()
            .suggestAFriend(referAFriend: referAFriendModel);

        if (res.status == ApiResponseStatus.completed) {
          Get.offAllNamed(Routes.HOME);
          isloading.value = false;
        } else {
          isloading.value = false;
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      isloading.value = false;
    }
  }
}

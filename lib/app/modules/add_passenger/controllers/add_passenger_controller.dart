// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/style.dart';

import '../../../data/models/network_models/razorpay_model.dart';
import '../../../data/models/network_models/travellers_model.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/add_passenger_view.dart';

class AddPassengerController extends GetxController
    with StateMixin<AddPassengerView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  final TextEditingController controller = TextEditingController();
  final DateTime selectedDate = DateTime.now();
  int? orderID;
  int? totalTravellers;
  Rx<OrderPaymentModel> orderPaymentModel = OrderPaymentModel().obs;
  RxList<TravellersModel> travellers = <TravellersModel>[].obs;
  RxBool isloading = false.obs;
  Rx<bool> isLoadingIc = false.obs;
  RxString image = ''.obs;
  Rx<String> customerAddress = ''.obs;
  Rx<String> customerName = ''.obs;
  Rx<String> customerPhone = ''.obs;
  Rx<String> customerAdhaar = ''.obs;
  Rx<String> customerDOB = ''.obs;
  @override
  void onInit() {
    super.onInit();

    loadData();
  }

  String? dobValidator(String? value) => DateTime.tryParse(value ?? '') != null
      ? null
      : 'Please enter a valid DOB';
  String? nameValidator(String? value) => GetUtils.isLengthLessOrEqual(value, 3)
      ? 'Please enter a valid name'
      : null;

  String? phoneNumberValidator(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 9)
          ? 'Please enter a valid phone number'
          : null;

  String? addressValidator(String? value) =>
      GetUtils.isLengthGreaterOrEqual(value, 10)
          ? null
          : 'please enter a valid address';

  void loadData() {
    if (Get.arguments != null) {
      change(null, status: RxStatus.loading());
      orderID = Get.arguments[0] as int;
      totalTravellers = Get.arguments[1] as int;
      change(null, status: RxStatus.success());
    }
  }

  Future<void> onRegisterClicked() async {
    if (formKey.currentState!.validate()) {
      if (image.value != '') {
        isloading.value = true;
        final ApiResponse<bool> res = await PassengerRepository().addpassenger(
            customerName.value,
            customerPhone.value,
            orderID.toString(),
            customerDOB.value,
            customerAddress.value,
            image.value);
        if (res.status == ApiResponseStatus.completed) {
          image.value = '';
          await getTravellers(orderID).whenComplete(() => Get.back());
        } else {
          CustomDialog().showCustomDialog("Can't add the passenger",
              'Please check the all details that you entered');
        }
        isloading.value = false;
      } else {
        Get.snackbar('Add your ID proof', 'Add any ID proof',
            backgroundColor: englishViolet, colorText: Colors.white);
      }
    }
    isloading.value = false;
  }

  Future<void> getImage(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      image.value = pickedFile.path;
      log('pickedfile ${pickedFile.path.split('/').last}');
    }
  }

  Future<void> getTravellers(int? orderID) async {
    final ApiResponse<List<TravellersModel>> res =
        await PassengerRepository().getAllPassengersByOrderId(orderID!);
    if (res.data != null) {
      travellers.value = res.data!;
    } else {}
  }

  void gotoCheckoutPage() {
    isLoadingIc.value = true;
    CustomDialog().showCustomDialog('Are your Ready \nto checkout',
        "Please double check \n the data's you entered\n before checkout",
        cancelText: 'Go back', onCancel: () {
      Get.back();
      isLoadingIc.value = false;
    }, onConfirm: () {
      Get.back();
      Get.offAllNamed(Routes.CHECKOUT_SCREEN);
      isLoadingIc.value = false;
    });
    isLoadingIc.value = false;
  }
}

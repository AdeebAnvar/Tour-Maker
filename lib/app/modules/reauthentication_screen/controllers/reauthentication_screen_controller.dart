import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/reauthentication_screen_view.dart';

class ReauthenticationScreenController extends GetxController
    with StateMixin<ReauthenticationScreenView> {
  CountdownController countDownController = CountdownController();
  TextEditingController textEditorController = TextEditingController();
  GetStorage getStorage = GetStorage();
  String? phone;
  String? verID;
  RxBool isLoading = false.obs;
  RxString otpCode = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    loadData();
    await SmsAutoFill().listenForCode();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    countDownController.start();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    SmsAutoFill().unregisterListener();
    textEditorController.dispose();
  }

  void loadData() {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      verID = Get.arguments[0] as String;
      phone = Get.arguments[1] as String;
    }
    change(null, status: RxStatus.success());
  }

  Future<void> authenticate() async {
    isLoading.value = true;

    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          smsCode: otpCode.value, verificationId: verID!);
      await user.reauthenticateWithCredential(credential);
      await user
          .delete()
          .then((dynamic value) => Get.offAllNamed(Routes.GET_STARTED));
    } catch (e) {
      await CustomDialog().showCustomDialog(
        'OOPS...!',
        contentText: 'You entered wrong OTP!!',
        confirmText: 'Give me another OTP',
        cancelText: 'Change my number',
        onConfirm: () {
          Get.back();
          onResendinOTP();
        },
        onCancel: () {
          Get.back();

          Get.offAllNamed(Routes.USER_REGISTERSCREEN);
        },
      );
      isLoading.value = false;
    }
  }

  Future<void> onResendinOTP() async {
    change(null, status: RxStatus.loading());
    countDownController.restart();
    final FirebaseAuth auth = FirebaseAuth.instance;
    void verificationCompleted(AuthCredential phoneAuthCredential) {}
    void verificationFailed(FirebaseAuthException exception) {}
    Future<void> codeSent(String verificationId,
        [int? forceResendingToken]) async {
      final String verificationid = verificationId;
      Get.toNamed(
        Routes.OTP_SCREEN,
        arguments: <dynamic>[
          verificationid,
          phone.toString(),
        ],
      );
      change(null, status: RxStatus.success());
    }

    void codeAutoRetrievalTimeout(String verificationId) {}
    await auth.verifyPhoneNumber(
      phoneNumber: phone.toString(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
    textEditorController.text = '';
    change(null, status: RxStatus.success());
  }
}

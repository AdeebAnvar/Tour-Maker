import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/theme/style.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_dialogue.dart';

class GetStartedController extends GetxController with StateMixin<dynamic> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GetStorage storage = GetStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;
  int? otp;
  RxBool isButtonVisible = true.obs;
  RxBool isloading = false.obs;
  RxBool isClicked = false.obs;
  RxString authStatus = ''.obs;
  Rx<bool> isFinished = false.obs;
  String? phone;
  String? verificationid;
  Rx<Country> selectedCountry = Country(
          phoneCode: '91',
          countryCode: 'IN',
          e164Sc: 0,
          geographic: true,
          level: 1,
          name: 'India',
          example: 'India',
          displayName: 'India',
          displayNameNoCountryCode: 'IN',
          e164Key: '')
      .obs;
  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
  }

  void onCountryCodeClicked(BuildContext context) {
    showCountryPicker(
      countryListTheme: CountryListThemeData(
          backgroundColor: Colors.white,
          bottomSheetHeight: 500,
          textStyle: subheading1),
      context: context,
      onSelect: (Country value) => selectedCountry.value = value,
    );
  }

  Future<void> onVerifyPhoneNumber() async {
    if (formKey.currentState!.validate()) {
      isloading.value = true;
      final String phoneNumber = '+${selectedCountry.value.phoneCode}$phone';
      final FirebaseAuth auth = FirebaseAuth.instance;
      try {
        await auth
            .verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            isloading.value = false;
            CustomDialog().showCustomDialog(
                'Phone number $phoneNumber verification failed.',
                contentText:
                    'Code: ${authException.code}. Message: ${authException.message}');
          },
          codeSent: (String verificationId, [int? forceResendingToken]) async {
            verificationid = verificationId;
            await Get.toNamed(Routes.OTP_SCREEN, arguments: <dynamic>[
              verificationId,
              phoneNumber,
              forceResendingToken
            ]);
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        )
            .catchError((dynamic e) {
          CustomDialog().showCustomDialog('Error !', contentText: e.toString());
        });
      } catch (e) {
        isloading.value = false;
      }
    } else {}
  }

  String? phoneNumberValidator(String value) =>
      GetUtils.isLengthEqualTo(value, 10)
          ? null
          : 'Please enter a valid phone number';

  Future<void> onClickDemoOfTheApp() async {
    isloading.value = true;
    const String phoneNumber = '+918330075573';
    // Send the verification code to the user's phone.
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential verificationId) {
        log('Verification ID: $verificationId');
      },
      verificationFailed: (FirebaseAuthException error) {
        log('Verification failed: $error');
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        log('Code sent: $verificationId');
        try {
          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(
            PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: '123456',
            ),
          );
          final User user = userCredential.user!;
          if (user.uid != null) {
            final IdTokenResult idTokenResult =
                await user.getIdTokenResult(true);
            final String token = idTokenResult.token!;
            await storage.write('token', token).then(
                  (value) async =>
                      await storage.write('user-type', 'demo').whenComplete(
                            () => Get.toNamed(Routes.HOME),
                          ),
                );
          }
          log('Signed in');
        } catch (error) {
          log('Error signing in: $error');
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('Code auto retrieval timed out: $verificationId');
      },
    );

    isloading.value = false;
  }
}

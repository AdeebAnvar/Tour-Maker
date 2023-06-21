import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../widgets/custom_dialogue.dart';

class FireBaseFunctions {
  Future<void> sendPhoneNumberToFirebase({required String phoneNumber}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    await auth
        .verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential authCredential) async {},
      verificationFailed: (FirebaseAuthException authException) {
        CustomDialog().showCustomDialog(
            'Phone number $phoneNumber verification failed.',
            contentText:
                'Code: ${authException.code}. Message: ${authException.message}');
      },
      codeSent: (String verificationId, [int? forceResendingToken]) async {
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
  }

  void signInWithOTP() {}
  void generateToken() {}
  void checkUserLoggedInORnot() {}
  void getUserPhoneNumber() {}
}

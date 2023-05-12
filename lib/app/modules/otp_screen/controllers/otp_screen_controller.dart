import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/otp_screen_view.dart';

class OtpScreenController extends GetxController
    with StateMixin<OtpScreenView> {
  CountdownController countDownController =
      CountdownController(); //  Count down of otp recieving from User
  TextEditingController textEditorController =
      TextEditingController(); //  controll the OTP from user
  GetStorage getStorage = GetStorage(); //  store values to locally
  String? phone; //  Store phone number from GET started screen
  String? verID; //  Store verification ID from Get started screen
  RxBool isLoading = false.obs; // controll the animation of submit button
  RxString otpCode = ''.obs; //  controll  the otp from user / Firebase

  @override
  Future<void> onInit() async {
    super.onInit();
    // Get Data from Previous Screen (Get started screen)
    loadData();
    // Listen for sms from firebase to auto fetch the otp
    await SmsAutoFill().listenForCode();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // Start the count down to revcieve the otp
    countDownController.start();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    // Stop the OTP listener
    SmsAutoFill().unregisterListener();
    // dispose the text controller
    textEditorController.dispose();
  }

  void loadData() {
    change(null, status: RxStatus.loading());
    // Get the datas from Previous Screen (Get Started Screen)
    if (Get.arguments != null) {
      verID = Get.arguments[0] as String;
      phone = Get.arguments[1] as String;
    }
    change(null, status: RxStatus.success());
  }

  // signIn function Works when the otp code auto fetched  . or user click the submit button
  // Which uses the firebase Phone Authentication to signIN the user .
  // OTP generate from Firebase by using the phone number which given by the user
  Future<void> signIn() async {
    isLoading.value = true; //  Submit button Animation Starts
    final FirebaseAuth auth = FirebaseAuth.instance;
    // Create/Get the credentials of user by using  the verification which was
    //  get from previous screen (Get Started) and THe OTP code which generated from firebase
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verID.toString(),
      smsCode: otpCode.toString(),
    );

    try {
      //Start the sign In process of firebase by using the credentials of user
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      // Got the user by using the credentials of the user
      final User user = userCredential.user!;
      // Check if the user entered the correct OTP
      if (user.uid != null) {
        // Generate user Token from Firebase and store it to getstorage as the key value of token
        final IdTokenResult idTokenResult = await user.getIdTokenResult(true);
        final String token = idTokenResult.token!;
        await getStorage.write('token', token);
        // Check if the user exists or not
        await checkUserExistsORnot();
      }
    } catch (e) {
      // Handle incorrect OTP here
      await CustomDialog().showCustomDialog(
        'OOPS...!',
        'You entered wrong OTP!!',
        confirmText: 'Give me another OTP',
        cancelText: 'Change my number',
        onConfirm: () {
          Get.back();
          onResendinOTP();
        },
        onCancel: () {
          Get.offAllNamed(Routes.GET_STARTED);
        },
      );
      isLoading.value = false;
    }
  }

  Future<void> onResendinOTP() async {
    change(null, status: RxStatus.loading());
    // when timed out to enterr the otp this function will resend the otp Code to user to enter again
    countDownController.restart();
    final FirebaseAuth auth = FirebaseAuth.instance;
    void verificationCompleted(
        AuthCredential phoneAuthCredential) {} // Empty Function!!!!!
    void verificationFailed(
        FirebaseAuthException exception) {} // Empty Function!!!!!
    // After Sending the otp code to user
    Future<void> codeSent(String verificationId,
        [int? forceResendingToken]) async {
      final String verificationid = verificationId;
      Get.toNamed(
        Routes.OTP_SCREEN,
        arguments: <dynamic>[
          verificationid,
          phone.toString(),
        ], // forceToken],
      );
      change(null, status: RxStatus.success());
    }

    void codeAutoRetrievalTimeout(
        String verificationId) {} // Empty Function!!!!!
    // Verify the phone number using the OTP from firebase
    await auth.verifyPhoneNumber(
      phoneNumber: phone.toString(),
      // Time fpr the otp is 1 minute
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
    textEditorController.text = '';
    change(null, status: RxStatus.success());
  }

  // After verifying the The user via firebase check the user is in ro not in the server
  Future<void> checkUserExistsORnot() async {
    // Get user Data from Database
    final ApiResponse<UserModel> res = await UserRepository().getUserDetails();
    if (res.status == ApiResponseStatus.completed) {
      final UserModel user = res.data!;
      // If the verifyed user is exists on Database user will be redirect to home screen
      // otherwise user will be redirected to login screen
      if (user.phoneNumber == phone) {
        // send an FCM token to server
        await notificationPermission();
        // store the adddresss and category of the user for later use the key value of both are
        // currentUserAddress and currentUserCategory
        await getStorage.write('currentUserAddress', user.address);
        await getStorage.write('currentUserCategory', user.category);
        await Get.offAllNamed(Routes.HOME);
        isLoading.value = false; // Stop the submit button animation
      } else {
        // send an FCM token to server
        await notificationPermission();
        Get.offAllNamed(Routes.LOGIN, arguments: phone);
        // store the adddresss of the user for later use he key value of both are
        // currentUserAddress
        await getStorage.write('currentUserAddress', '');
        isLoading.value = false; // Stop the submit button animation
      }
    }
  }

// Then After We need to generate FCM token and update the FCM Token (Firebase Cloud Messaging)
  Future<void> notificationPermission() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    // Ask permission to user to send notification
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // When the user give permission to notification we need to store a value in getstorage that the
      // notification accepted or not by user .  the key is isNotificationON
      await getStorage.write('isNotificationON', 'true');
      // generate FCM token
      final String? fcmToken = await messaging.getToken();
      // Send the FCM token to server to update the token to send notification to user
      final ApiResponse<Map<String, dynamic>> res =
          await UserRepository().postFCMToken(fcmToken!);
      if (res.status == ApiResponseStatus.completed) {
        // if the FCM token is updated show a snackbar
        Get.snackbar('Notification Allowed by You',
            'You will recieve offers nd updates from TourMaker',
            colorText: Colors.white, backgroundColor: englishViolet);
      }
    } else {
      // When user didn't allow the the permission to send notification we need to store a value in getstorage that the
      // notification accepted or not by user .  the key is isNotificationON . and also show a snackbar
      await getStorage.write('isNotificationON', 'false');
      Get.snackbar('Notification Not Allowed by You', '',
          colorText: Colors.white, backgroundColor: englishViolet);
    }
  }
}

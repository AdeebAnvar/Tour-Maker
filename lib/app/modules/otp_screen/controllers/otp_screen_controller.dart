import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../../../core/theme/style.dart';
import '../../../../main.dart';
import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/otp_screen_view.dart';

class OtpScreenController extends GetxController
    with StateMixin<OtpScreenView> {
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

  Future<void> signIn() async {
    isLoading.value = true;

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verID.toString(),
        smsCode: otpCode.toString(),
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User user = userCredential.user!;
      if (user.uid != null) {
        final IdTokenResult idTokenResult = await user.getIdTokenResult(true);
        final String token = idTokenResult.token!;
        await getStorage.write('token', token);
        await checkUserExistsORnot();
      }
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

          Get.offAllNamed(Routes.GET_STARTED);
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

  Future<void> checkUserExistsORnot() async {
    final ApiResponse<UserModel> res = await UserRepository().getUserDetails();
    if (res.status == ApiResponseStatus.completed) {
      final UserModel user = res.data!;
      if (user.phoneNumber == phone) {
        await notificationPermissionWithPutmethod();
        await getStorage.write('currentUserAddress', user.address);
        await getStorage.write('currentUserCategory', user.category);
        await getStorage.write('newUser', 'false');
        user.paymentStatus != '' && user.paymentStatus != null
            ? await getStorage.write('initialPayment', 'paid')
            : await getStorage.write('initialPayment', '');
        await Get.offAllNamed(Routes.HOME);
        await getStorage.write('user-type', 'real');

        isLoading.value = false;
      } else {
        await notificationPermissionwithPostMethod();
        Get.offAllNamed(Routes.LOGIN, arguments: phone);
        isLoading.value = false;
      }
    }
  }

  Future<void> notificationPermissionWithPutmethod() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: englishViolet,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        CustomDialog().showCustomDialog(notification.title!,
            contentText: notification.body);
      }
    });
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await getStorage.write('isNotificationON', 'true');
      final String? fcmToken = await messaging.getToken();
      final ApiResponse<Map<String, dynamic>> res =
          await UserRepository().putFCMToken(fcmToken!);
      if (res.status == ApiResponseStatus.completed) {
        await getStorage.write('isNotificationON', 'true');
      }
    } else {
      await getStorage.write('isNotificationON', 'false');
    }
  }

  Future<void> notificationPermissionwithPostMethod() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: englishViolet,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        CustomDialog().showCustomDialog(notification.title!,
            contentText: notification.body);
      }
    });
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await getStorage.write('isNotificationON', 'true');
      final String? fcmToken = await messaging.getToken();
      final ApiResponse<Map<String, dynamic>> res =
          await UserRepository().postFCMToken(fcmToken!);
      if (res.status == ApiResponseStatus.completed) {
        await getStorage.write('isNotificationON', 'true');
      }
    } else {
      await getStorage.write('isNotificationON', 'false');
    }
  }
}

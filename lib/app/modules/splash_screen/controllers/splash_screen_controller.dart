import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../core/utils/constants.dart';
import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';

dynamic fcmtoken;

class SplashScreenController extends GetxController with StateMixin<dynamic> {
  final GetStorage getStorage = GetStorage();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Rx<bool> isInternetConnect = true.obs;

  // RxBool a = false.obs;
  // RxBool b = false.obs;
  // RxBool c = false.obs;
  // RxBool d = false.obs;
  // RxBool e = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();

    isInternetConnectFunction();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // print('dsf');
    log('re');
    await checkUserLoggedInORnOT();
  }

  Future<void> isInternetConnectFunction() async {
    log('inernet');
    isInternetConnect.value = await InternetConnectionChecker().hasConnection;
    isInternetConnect.value != true
        ? Get.toNamed(Routes.NOINTERNET)
        : checkUserLoggedInORnOT();
  }

  Future<void> checkUserLoggedInORnOT() async {
    log('checking. . . . ');

    try {
      if (currentUser != null) {
        log('New Loogin splsh${currentUser?.phoneNumber}');
        // final CurrentUserModel cm =
        //     CurrentUserModel(userPhoneNumber: currentUser?.phoneNumber);
        // await CurrentUserRepository.saveUserData(cm);
        final String token = await currentUser!.getIdToken(true);
        await getStorage.write('token', token);
        log('adeeb token frm splsh $token');
        // sendFCM(token);
        checkUserExistsOnDB(token);
      } else {
        log(' user is not logged in firebase');
        await Get.offAllNamed(Routes.GET_STARTED);
      }
    } catch (e) {
      log('catch $e');
    }
  }

  Future<void> putFcm() async {
    log('send fcm');
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //authorized
      isNotificationON = true;
      final String? fcmToken = await messaging.getToken();
      fcmtoken = fcmToken;
      log('fcm $fcmToken');
      final ApiResponse<Map<String, dynamic>> res =
          await UserRepository().putFCMToken(fcmToken);
      if (res.status == ApiResponseStatus.completed) {
        // checkUserExistsOnDB(token, fcmToken);
      } else {
        log('req not send');
      }
    } else {
      //not authorized
      isNotificationON = false;
    }
  }

  Future<void> checkUserExistsOnDB(dynamic token) async {
    log('check user');
    final ApiResponse<UserModel> res = await UserRepository().getUserDetails();
    if (res.data != null) {
      await Get.offAllNamed(Routes.HOME);
    } else {
      await Get.offAllNamed(Routes.LOGIN, arguments: currentUser?.phoneNumber);

      postFcm();
    }
  }

  Future<void> postFcm() async {
    log('send fcm');
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //authorized
      isNotificationON = true;
      final String? fcmToken = await messaging.getToken();
      fcmtoken = fcmToken;
      log('fcm $fcmToken');
      final ApiResponse<Map<String, dynamic>> res =
          await UserRepository().postFCMToken(fcmToken!);
      if (res.status == ApiResponseStatus.completed) {
        // checkUserExistsOnDB(token, fcmToken);
      } else {
        log('req not send');
      }
    } else {
      //not authorized
      isNotificationON = false;
    }
  }
}

// String? tndc;

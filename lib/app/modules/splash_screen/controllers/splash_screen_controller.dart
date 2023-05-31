import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../core/theme/style.dart';
import '../../../../main.dart';
import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';

class SplashScreenController extends GetxController with StateMixin<dynamic> {
  final GetStorage getStorage = GetStorage(); //  store values to local storage
  final User? currentUser = FirebaseAuth
      .instance.currentUser; //  Take the detailsof the current user in firebase
  Rx<bool> isInternetConnect = true.obs; // check network is connected is not
  @override
  Future<void> onInit() async {
    super.onInit();
    // check connection(Wifi/Data)

    await isInternetConnectFunction();
    log('message 1');
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    log('message 2');
    // check The user logged in Firebase or Not
    await checkUserLoggedInORnOT();
  }

  // Check Network Connection (WiFi/Data)
  Future<void> isInternetConnectFunction() async {
    log('message 3');
    // If the network connection is Availble which goes to check the user logged in or not
    // otherwise it will go no Internet screen which redirect to here .
    // The variable isInternetConnect is checks the network connection(WiFi/Data) is active or Not
    isInternetConnect.value = await InternetConnectionChecker().hasConnection;
    isInternetConnect.value != true
        ? await Get.toNamed(Routes.NOINTERNET)
        : await checkUserLoggedInORnOT();
  }

  Future<void> checkUserLoggedInORnOT() async {
    // This Function Checks that User is Logged into app or not
    log('message 4');
    try {
      if (currentUser != null) {
        // If suppose the user installed the app and logged in ,  we need generate a token from firebase .
        //  and needs to store it . The generated token is passing through every API request .
        // Token will be stored in getstorage as the key name of 'token'
        final String token = await currentUser!.getIdToken(true);
        await getStorage.write('token', token);
        log(token);
        // After The Token stored We need to aSK PERMISSION TO SEND NOTIFCATION

        await notificationPermissionwithPutMethod();
        // After The Token stored We need to check that the user Exists on Database .  which will be checked
        // by the checkUserExistsOnDB function .  We need to pass the generated token to check user  is in Database or not .
        await checkUserExistsOnDB();
      } else {
        // If suppose the user unInstalled the app or not logged into . We need redirect the user to getstarted screen .
        //  Therefore we need to authenticate the user by using firebase authentication
        await Get.offAllNamed(Routes.GET_STARTED);
      }
    } catch (e) {
      // If suppose any error occured by running the checkUserLoggedInORnOT function user can visible the error.
      // and easily report the error by using the dialogue shown with the error message
      await CustomDialog()
          .showCustomDialog('Error !', contentText: e.toString());
    }
  }

  // If the User logged in We need to generate FCM token and update the FCM Token (Firebase Cloud Messaging)
  Future<void> notificationPermissionwithPutMethod() async {
    log('message 5');
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

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        log('A new onMessageOpenedApp event was published!');
        final RemoteNotification? notification = message.notification;
        final AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          CustomDialog().showCustomDialog(notification.title!,
              contentText: notification.body);
        }
      },
    );
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    // Ask permission to user to send notification
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // When the user give permission to notification we need to store a value in getstorage that the
      // notification accepted or not by user .  the key is isNotificationON
      await getStorage.write('isNotificationON', 'true');
      // generate FCM token
      final String? fcmToken = await messaging.getToken();
      messaging.onTokenRefresh;
      log(fcmToken!);
      // Send the FCM token to server to update the token to send notification to user
      final ApiResponse<Map<String, dynamic>> res =
          await UserRepository().putFCMToken(fcmToken);
      log('message ${res.message}');

      if (res.status == ApiResponseStatus.completed) {}
    } else {
      // When user didn't allow the the permission to send notification we need to store a value in getstorage that the
      // notification accepted or not by user .  the key is isNotificationON . and also show a snackbar
      await getStorage.write('isNotificationON', 'false');
    }
  }

  // If the User logged in We need to generate FCM token and update the FCM Token (Firebase Cloud Messaging)
  Future<void> notificationPermissionwithPostMethod() async {
    log('message 5');
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      final NotificationSettings settings = await messaging.requestPermission();
      // Ask permission to user to send notification
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // When the user give permission to notification we need to store a value in getstorage that the
        // notification accepted or not by user .  the key is isNotificationON
        await getStorage.write('isNotificationON', 'true');
        // generate FCM token
        final String? fcmToken = await messaging.getToken();

        log(fcmToken!);
        // Send the FCM token to server to update the token to send notification to user
        final ApiResponse<Map<String, dynamic>> res =
            await UserRepository().postFCMToken(fcmToken);
        log('message ${res.message}');

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
    } catch (e) {
      log('iuugui $e');
    }
  }

  //  We nned to check the user is exists or Not exists in Databse by sending the
  //  firebase generated token to server
  Future<void> checkUserExistsOnDB() async {
    log('message 6');
    final ApiResponse<UserModel> res = await UserRepository().getUserDetails();
    // we will get a response the user exists or not by checking the userdata is empty or not .
    // if the user data is empty the user isn't exist in Database so the user will redirect to Login screen
    // Otherwise the user will redirect to Home Screen
    if (res.data != null) {
      final UserModel user = res.data!;
      if (user.tAndCStatus == 'true') {
        await getStorage.write('currentUserAddress', user.address);
        await getStorage.write('currentUserCategory', user.category);
        await getStorage.write('newUser', 'false');

        user.paymentStatus != '' && user.paymentStatus != null
            ? await getStorage.write('initialPayment', 'paid')
            : await getStorage.write('initialPayment', '');
        await Get.offAllNamed(Routes.HOME);
      } else {
        await getStorage.write('newUser', 'true');
        Get.offAllNamed(Routes.TERMS_AND_CONDITIONS);
      }
    } else {
      await notificationPermissionwithPostMethod();
      await Get.offAllNamed(Routes.LOGIN, arguments: currentUser?.phoneNumber);
    }
  }
}

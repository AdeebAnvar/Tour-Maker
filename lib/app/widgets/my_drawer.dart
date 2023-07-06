import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/style.dart';

import '../../core/tour_maker_icons.dart';
import '../data/models/network_models/user_model.dart';
import '../modules/profile/controllers/profile_controller.dart';
import '../routes/app_pages.dart';
import 'custom_dialogue.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key, this.userController, this.profileController});
  final UserModel? userController;
  final ProfileController? profileController;
  final Rx<bool> isNotificationON = true.obs;
  final Rx<bool> appRelatedQueries = false.obs;
  final Rx<bool> businessQueries = false.obs;
  final Rx<bool> deactivateAccount = false.obs;
  final Rx<bool> other = false.obs;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 38.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Hi ${userController?.name}', style: heading2),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => onClickRewards(),
                        child: Container(
                          width: 33.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(TourMaker.vector, color: englishViolet),
                              const Text('Rewards'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => onClickPayments(),
                        child: Container(
                          width: 33.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(TourMaker.transaction_arrow_1,
                                  color: englishViolet),
                              const Text('Payments'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(TourMaker.notification, color: englishViolet),
                      const Text('Notifications'),
                      Obx(() {
                        // final GetStorage storage = GetStorage();
                        // final String notification =
                        //     storage.read('isNotificationON') as String;
                        // if (notification == 'true') {
                        //   isNotificationON.value = true;
                        // } else {
                        //   isNotificationON.value = false;
                        // }

                        return Switch(
                          value: isNotificationON.value,
                          activeColor: englishViolet,
                          onChanged: (bool value) =>
                              onToggleNotification(value),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () => onClickPrivacyPolicy(context),
                leading: Icon(TourMaker.group_2, color: englishViolet),
                title: const Text('Privacy Policy'),
              ),
              ListTile(
                onTap: () => onClickTermsOFuse(context),
                leading: Icon(TourMaker.group, color: englishViolet),
                title: const Text('Terms Of Use'),
              ),
              ListTile(
                onTap: () => onClickHelp(context),
                leading: SvgPicture.asset('assets/help.svg', height: 25),
                title: const Text('Help'),
              ),
              ListTile(
                onTap: () => onClickAbout(context),
                leading: SvgPicture.asset('assets/about.svg', height: 25),
                title: const Text('about'),
              ),
              ListTile(
                onTap: onClickFeedBack,
                leading: SvgPicture.asset('assets/feedback.svg', height: 25),
                title: const Text('Feedback'),
              ),
              ListTile(
                onTap: () =>
                    onClickEditProfile(profileController!.userType.toString()),
                leading: Icon(Icons.edit, color: englishViolet),
                title: const Text('Edit My Profile'),
              ),
              ListTile(
                onTap: () => onLogoutPressed(context),
                leading: Icon(TourMaker.logout, color: englishViolet),
                title: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onLogoutPressed(BuildContext context) {
    CustomDialog().showCustomDialog(
      'Do you really want to logout from TourMaker?',
      cancelText: 'Go Back',
      confirmText: 'Logout',
      onCancel: () => cancel(),
      onConfirm: () => logout(),
    );
  }

  void onClickRewards() => Get.toNamed(Routes.REWARDS);

  void onClickPayments() => Get.toNamed(Routes.PAYMENT_SCREEN);

  Future<void> onClickHelp(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Seek our help!'),
          content: Container(
            padding: const EdgeInsets.all(8),
            height: 259,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      title: const Text('App related queries'),
                      onTap: () {
                        appRelatedQueries.value = true;
                        businessQueries.value = false;
                        deactivateAccount.value = false;
                        other.value = false;
                        onclickSingleHelp();
                        Get.back();
                      }),
                  ListTile(
                      title: const Text('Business Enqueries'),
                      onTap: () {
                        appRelatedQueries.value = false;
                        businessQueries.value = true;
                        deactivateAccount.value = false;
                        other.value = false;
                        onclickSingleHelp();
                        Get.back();
                      }),
                  ListTile(
                      title: const Text('Delete my account'),
                      onTap: () async {
                        appRelatedQueries.value = false;
                        businessQueries.value = false;
                        deactivateAccount.value = true;
                        other.value = false;
                        Get.back();
                        await onClickDeleteMyAccount();
                      }),
                  ListTile(
                      title: const Text('Other'),
                      onTap: () {
                        appRelatedQueries.value = false;
                        businessQueries.value = false;
                        deactivateAccount.value = false;
                        other.value = true;
                        onclickSingleHelp();
                        Get.back();
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onClickFeedBack() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'tourmakerinfo@gmail.com',
      query: 'subject=Hi , I am ${userController?.name}',
    );
    final String url = params.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)).whenComplete(() => Get.snackbar(
          'Got the mail',
          'we got your request via mail \nwe will reach out you soon'));
    } else {
      Get.snackbar('SORRY!!!', 'Could not launch $url');
    }
  }

  Future<void> onclickSingleHelp() async {
    if (appRelatedQueries.value == true) {
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'tourmakerinfo@gmail.com',
        query:
            'subject=I am ${userController?.name} , i need help about TourMaker app',
      );
      final String url = params.toString();
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        Get.snackbar('SORRY!!!', 'Could not launch $url');
      }
    } else if (businessQueries.value == true) {
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'tourmakerinfo@gmail.com',
        query:
            'subject=I am ${userController?.name} , i would like to collab with TourMaker app',
      );
      final String url = params.toString();
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        Get.snackbar('SORRY!!!', 'Could not launch $url');
      }
    } else if (deactivateAccount.value == true) {
      // final Uri params = Uri(
      //   scheme: 'mailto',
      //   path: 'tourmakerinfo@gmail.com',
      //   query:
      //       'subject=I am ${controller?.name} , I need to deactivate/ delete my data from TourMaker app',
      // );
      // final String url = params.toString();
      // if (await canLaunchUrl(Uri.parse(url))) {
      //   await launchUrl(Uri.parse(url));
      // } else {
      //   Get.snackbar('SORRY!!!', 'Could not launch $url');
      // }
    } else {
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'tourmakerinfo@gmail.com',
        query:
            'subject=I am ${userController?.name} , i need help about TourMaker app',
      );
      final String url = params.toString();
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        Get.snackbar('SORRY!!!', 'Could not launch $url');
      }
    }
  }

  Future<void> onClickDeleteMyAccount() async {
    CustomDialog().showCustomDialog('Are you sure ??',
        contentText:
            'After delete your profile all of your data will be removed from our server . it cant be reversible !!.',
        confirmText: 'Delete',
        cancelText: 'Go Back', onCancel: () {
      Get.back();
    }, onConfirm: () async {
      Get.back();
      await reauthenticateUser();
    });
  }

  Future<void> reauthenticateUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth
          .verifyPhoneNumber(
        phoneNumber: auth.currentUser!.phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential authCredential) async {},
        verificationFailed: (FirebaseAuthException authException) {
          CustomDialog().showCustomDialog(
              'Phone number ${auth.currentUser!.phoneNumber} verification failed.',
              contentText:
                  'Code: ${authException.code}. Message: ${authException.message}');
        },
        codeSent: (String verificationId, [int? forceResendingToken]) async {
          await Get.toNamed(Routes.REAUTHENTICATION_SCREEN,
              arguments: <dynamic>[
                verificationId,
                auth.currentUser!.phoneNumber,
                forceResendingToken
              ]);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      )
          .catchError((dynamic e) {
        CustomDialog().showCustomDialog('Error !', contentText: e.toString());
      });
    } catch (e) {}
  }

  Future<void> logout() async {
    final GetStorage storage = GetStorage();
    await storage.write('currentUserAddress', '');
    await storage.write('currentUserCategory', '');
    await storage.write('currentUserName', '');
    await storage.write('currentUserCountry', '');
    await storage.write('currentUserDistrict', '');
    await storage.write('currentUserEmail', '');
    await storage.write('currentUserEnterpriseName', '');
    await storage.write('currentUserGender', '');
    await storage.write('currentUserPhoneNumber', '');
    await storage.write('currentUserState', '');
    await FirebaseAuth.instance.signOut().then(
          (dynamic value) async => await Get.offAllNamed(Routes.GET_STARTED),
        );
  }

  void cancel() => Get.back();

  Future<void> onToggleNotification(bool value) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    isNotificationON.value = value;
    if (value) {
      try {
        // Ask the user for permission to receive notifications
        final NotificationSettings settings =
            await firebaseMessaging.requestPermission();
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          // Subscribe the user to the topic "all" to receive all notifications
          await firebaseMessaging.subscribeToTopic('all');
          isNotificationON.value = true;
        }
      } catch (e) {
        // Handle any errors that occur during permission request or subscription
        log('Error subscribing to notifications: $e');
      }
    } else {
      try {
        // Unsubscribe the user from the topic "all" to stop receiving notifications
        await firebaseMessaging.unsubscribeFromTopic('all');
        isNotificationON.value = false;
      } catch (e) {
        // Handle any errors that occur during unsubscription
        log('Error unsubscribing from notifications: $e');
      }
    }
  }

  Future<dynamic> onClickPrivacyPolicy(BuildContext ctx) {
    return Get.dialog(
      transitionCurve: Curves.easeInCubic,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 500),
      useSafeArea: true,
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon:
                          Icon(TourMaker.close_circle_1, color: englishViolet),
                    ),
                  ],
                ),
                Text(
                  '''
TOUR MAKER is an application designed to book tours of TRIPPENS’s tour operation company. Adventure tours, Package group tours, family package group tours, couple package tours, Ride tours, hiking, trucking etc. are available. This is basically not a customer focus app but for those who book tours on commission basis. For each and every tour package, company has fixed amount of commission for the agents on company’s wills.

For this application presently, we are not charging yearly charges or any registration fee. At this moment we have only 500Rs as service charges including tax. Tour payments are done only on GST tax basis. Bills and invoices will be done by TRIPPENS alone. And TRIPPENS will be responsible for all the tours operations.

Through this app we are not offering adequate income or a greater income. You get a commission proposed by company for the tours that you have chosen from the above.

The payments of the tours booked can be paid either through app or by bank through executives help or even from office within the time given by the executives. There will be an appointed time for the payment of booked tours and fail of payment with in that time given will result in cancellation of booking of the same. The responsibility of the balance amount of the booked tours lies with the agent alone.

The company have all the guaranteed rights to ban your login if we notice misuse of app by too much of fake bookings or unnecessary bookings.''',
                  style: subheading3,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 59),
                GestureDetector(
                  onTap: () => onTapViewMore(),
                  child: Text(
                    'view more > > >',
                    style: subheading3.copyWith(
                      color: englishlinearViolet,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> onClickTermsOFuse(BuildContext ctx) {
    return Get.dialog(
      transitionCurve: Curves.easeInCubic,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 500),
      useSafeArea: true,
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(TourMaker.close_circle_1,
                            color: englishViolet),
                      ),
                    ],
                  ),
                  Text(
                    '''
      1. if you're not able to reach out the destination on time. That is not our responsibility

      2. Hotel Check in time - 11.30 a.m. & checkout - 10.00 am.
      
      3. The booking stands liable to be cancelled if 100% payment is not received less than 20 days before
      date of departure. If the trip is cancel due to this reason advance will not be refundable. If you are
      not pay the amount that in mentioned in payment policy then tour will be cancel.
      
      4. There is no refund option in case you cancel the tour yourself.
      
      5. All activities which are not mentioned in the above itinerary such as visiting additional spots or
      involving in paid activities, If arranging separate cab etc. is not included in this.
      
      6. In case of using additional transport will be chargeable.
      
      7. All transport on the tour will be grouped together. Anyone who deviates from it will be excluded
      from this package.
      
      8. The company has the right for expelling persons who disagree with passengers or misrepresent
      the company during the trip.
      
      9. The company does not allow passengers to give tips to the driver for going additional spots.
      
      10. In case of cancellation due to any reason such as Covid, strike, problems on the part of railways,
      malfunctions, natural calamities etc., package amount will not be refunded.
      
      11. The Company will not be liable for any confirmation of train tickets, flight tickets, other
      transportation or any other related items not included in the package.
      
      12. In Case Of Events And Circumstances Beyond Our Control, We Reserve The Right To Change All
      Or Parts Of The Contents Of The Itinerary For Safety And Well Being Of Our Esteemed Passengers.
      
      13. Bathroom Facility | Indian or European
      
      14. In season rooms will not be the same as per itinerary but category will be the same (Budget
      economy).
      
      15. Charge will be the same from the age of 5 years.
      
      16. We are not providing tourist guide, if you are taking their service in your own cost we will not be
      responsible for the same.
      
      17. You Should reach to departing place on time, also you should keep the time management or you
      will not be able to cover all the place.
      
      18. If the climate condition affect the sightseeing that mentioned in itinerary, then we won’t provide
      you the additional spots apart from the itinerary.
      
      19. Transportation timing 8 am to 6 pm, if use vehicle after that then cost will be extra
      
      20. Will visit places as per itinerary only, if you visit other than this then cost will be extra
      
      21. If any customers misbehave with our staffs improperly then we will cancel his tour immediately
      and after that he can't continue with this tour.
      
      22. If the trip is not fully booked or cancelled due to any special circumstances, we will postpone the
      trip to another day. Otherwise, if the journey is to be done on the pre-arranged day, the customers
      will have to bear the extra money themselves.
      
      23. If you have any problems with the tour, please notify us as soon as possible so that we can
      resolve the problem. If you raise the issue after the tour, we will not be able to help you.
      
      24.Our company does not provide specific seats on the Volvo bus, if you need a seat particularly,
      please let the executive know during the confirmation of your reservation.(requires additional
      payment).''',
                    style: subheading1,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onClickAbout(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 260, horizontal: 25),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset('assets/Logo.png'),
                Text(
                  'App version 1.0.2',
                  textAlign: TextAlign.center,
                  style: subheading2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onClickEditProfile(String userType) {
    userType == 'demo'
        ? CustomDialog().showCustomDialog(
            'You need to log in again',
            cancelText: 'Go Back',
            confirmText: 'Ok',
            onCancel: () => Get.back(),
            onConfirm: () => Get.offAllNamed(Routes.GET_STARTED),
          )
        : Get.toNamed(Routes.USER_REGISTERSCREEN);
  }

  Future<void> onTapViewMore() async {
    final Uri url = Uri.parse('https://tourmaker.in/privacy.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomDialog()
          .showCustomDialog('Error !', contentText: "couldn't open to link");
    }
  }
}

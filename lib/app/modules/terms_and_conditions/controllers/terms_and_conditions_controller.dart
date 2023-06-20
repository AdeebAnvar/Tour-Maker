// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';

class TermsAndConditionsController extends GetxController {
  String termsAndCond = '''
TOUR MAKER is an application designed to book tours of TRIPPENS’s tour operation company. Adventure tours, Package group tours, family package group tours, couple package tours, Ride tours, hiking, trucking etc. are available. This is basically not a customer focus app but for those who book tours on commission basis. For each and every tour package, company has fixed amount of commission for the agents on company’s wills.

For this application presently, we are not charging yearly charges or any registration fee. At this moment we have only 500Rs as service charges including tax. Tour payments are done only on GST tax basis. Bills and invoices will be done by TRIPPENS alone. And TRIPPENS will be responsible for all the tours operations.

Through this app we are not offering adequate income or a greater income. You get a commission proposed by company for the tours that you have chosen from the above.

The payments of the tours booked can be paid either through app or by bank through executives help or even from office within the time given by the executives. There will be an appointed time for the payment of booked tours and fail of payment with in that time given will result in cancellation of booking of the same. The responsibility of the balance amount of the booked tours lies with the agent alone.

The company have all the guaranteed rights to ban your login if we notice misuse of app by too much of fake bookings or unnecessary bookings.''';

  String luckDrawContent = '''
Lucky draw will be conducted only after 10k app installations

If you can book minimum 2 tours within 20 days of your app installation, you will get 425 Rs from your service charge of 500 Rs after deducting the rax amount''';
  RxBool ischecked = false.obs;
  RxBool isLoading = false.obs;
  RxBool isButtonVisisble = false.obs;
  final RxInt count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void onConfirmDialogue() {
    //Get.toNamed(Routes.WELCOME_SCREEN);
  }

  void onCheck(bool value) {
    ischecked.value = value;
    ischecked.value
        ? isButtonVisisble.value = true
        : isButtonVisisble.value = false;
  }

  Future<void> onGetStartedClicked() async {
    isLoading.value = true;
    // final UserModel user = UserModel(
    //   tAndCStatus: 'true',
    // );
    final ApiResponse<Map<String, dynamic>> res =
        await UserRepository().updateUser(tAndCStatusOfUser: 'true');
    log('ihih ${res.data}');
    if (res.status == ApiResponseStatus.completed) {
      log('completed');
      Get.offAllNamed(Routes.LUCKY_DRAW);
      isLoading.value = false;
    } else {
      log('sdfgsg');
      isLoading.value = false;
    }
  }

  Future<void> onTapViewMore()async {
     final Uri url = Uri.parse('https://tourmaker.in/privacy.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomDialog().showCustomDialog('Error !',
          contentText: "couldn't open to link");
    }
  }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/theme/style.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../controllers/lucky_draw_controller.dart';

class LuckyDrawView extends GetView<LuckyDrawController> {
  const LuckyDrawView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        onLoading: const CustomLoadingScreen(),
        (dynamic state) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 18.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Center(
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      onFinished: () => controller.onFinished(),
                      animatedTexts: <AnimatedText>[
                        TypewriterAnimatedText(
                          '''Welcome ${controller.currentUserName}!\nGet ready for a chance to win big!\nwe're excited to announce that once we reach 10,000 users, we'll be conducting a lucky draw contest.\nstay tuned for more information on how to participate and the prizes you can win.\nin the meantime, invite your friends and family to join the app and increase your chances of being one of the lucky winners. \n LET'S REACH OUR GOAL TOGETHER!  ''',
                          speed: const Duration(milliseconds: 50), //50),
                          textAlign: TextAlign.left,
                          textStyle: const TextStyle(
                              letterSpacing: 3,
                              leadingDistribution: TextLeadingDistribution.even,
                              wordSpacing: 4,
                              fontFamily: 'Mesa',
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(
        () {
          return controller.isFinished.value
              ? showFloatingButton()
              : Container();
        },
      ),
    );
  }

  Widget showFloatingButton() => FloatingActionButton(
        autofocus: true,
        backgroundColor: englishViolet,
        onPressed: () {
          // showPaymentDialogue();
          Get.offAllNamed(Routes.HOME);
        },
        child: const Icon(Icons.arrow_forward),
      );

  // void showPaymentDialogue() {
  //   CustomDialog().showCustomDialog(
  //     'Hi $currentUserName',
  //     'Welcome to Tour Maker App',
  //     confirmText: 'Pay Rs. 424 + GST',
  //     cancelText: 'See a demo of the App',
  //     onConfirm: () => controller.onClickPayment(),
  //     onCancel: () => controller.onClickDemoApp(),
  //   );
  // }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/theme/style.dart';

import '../../../widgets/custom_loadinscreen.dart';
import '../controllers/lucky_draw_controller.dart';

class LuckyDrawView extends GetView<LuckyDrawController> {
  const LuckyDrawView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: controller.obx(
        onLoading: const CustomLoadingScreen(),
        (dynamic state) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 18.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    onFinished: () => controller.onFinishedHeading(),
                    animatedTexts: <AnimatedText>[
                      TypewriterAnimatedText(
                        'Free Tour Packages for Financially Challenged Travel Enthusiasts! . .  . \n',
                        speed: const Duration(milliseconds: 70),
                        curve: Curves.easeInCubic,
                        textAlign: TextAlign.justify,
                        textStyle: heading2.copyWith(
                            leadingDistribution: TextLeadingDistribution.even,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return controller.isFinishedHeading.value
                      ? Center(
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            onFinished: () => controller.onFinished(),
                            animatedTexts: <AnimatedText>[
                              TypewriterAnimatedText(
                                '''
Get ready for a chance to win big!\nwe're excited to announce that once we reach 10,000 users, we'll be conducting a lucky draw contest.\nstay tuned for more information on how to participate and the prizes you can win.\nin the meantime, invite your friends and family to join the app and increase your chances of being one of the lucky winners. 

If you have a beloved one who dreams of exploring these breathtaking locations but is unable to do so due to financial limitations, we invite you to recommend them to TourMaker's suugestion screen (which appears next).simply provide us with their contact information . Our team will carefully reviewand verify all submissions and select deserving individuals for the free tour packages.
Let's come together and make dreams come true! Nominate your beloved one now and let them experience the wonders of Kashmir or Manali without worrying about finances.
\n LET'S REACH OUR GOAL TOGETHER!''',
                                speed: const Duration(milliseconds: 50),
                                textAlign: TextAlign.justify,
                                textStyle: heading2.copyWith(
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                }),
              ],
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
        backgroundColor: englishViolet,
        onPressed: () => controller.onClickFoatingButton(),
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
/*TyperAnimatedText(
                          'Free Tour Packages for Financially Challenged Travel Enthusiasts!\n',
                          speed: const Duration(milliseconds: 50),
                          curve: Curves.easeInCubic,
                          textAlign: TextAlign.justify,
                          textStyle: heading2.copyWith(
                              leadingDistribution: TextLeadingDistribution.even,
                              fontWeight: FontWeight.w800),
                        ),*/ 
                        

                      

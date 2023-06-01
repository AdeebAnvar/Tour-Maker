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
Attention! We have an exciting opportunity for someone you know who loves to travel but is held back by financial constraints. We are offering free tour packages to the mesmerizing destinations of Kashmir or Manali!

If you have a beloved one who dreams of exploring these breathtaking locations but is unable to do so due to financial limitations, we invite you to recommend them to TourMaker's suugestion screen (which appears next) . Our aim is to make travel accessible to everyone, regardless of their financial background.

To nominate someone for this incredible opportunity, simply provide us with their contact information and a brief description of why they deserve to embark on this unforgettable journey. Our team will carefully reviewand verify all submissions and select deserving individuals for the free tour packages.

Let's come together and make dreams come true! Nominate your beloved one now and let them experience the wonders of Kashmir or Manali without worrying about finances.''',
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

                      
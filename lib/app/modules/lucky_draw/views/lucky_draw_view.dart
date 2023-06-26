import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';

import '../../../widgets/custom_elevated_button.dart';
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
        (LuckyDrawView? state) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 18.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(
                  () => controller.isClickNext.value
                      ? buildSuggestAFriend()
                      : buildLuckyDrawCard(),
                )
                //                 Center(
                //                   child: AnimatedTextKit(
                //                     isRepeatingAnimation: false,
                //                     onFinished: () => controller.onFinishedHeading(),
                //                     animatedTexts: <AnimatedText>[
                //                       TypewriterAnimatedText(
                //                         'Free Tour Packages for Financially Challenged Travel Enthusiasts! . .  . \n',
                //                         speed: const Duration(milliseconds: 70),
                //                         curve: Curves.easeInCubic,
                //                         textAlign: TextAlign.justify,
                //                         textStyle: heading2.copyWith(
                //                             leadingDistribution: TextLeadingDistribution.even,
                //                             fontWeight: FontWeight.w700),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 Obx(() {
                //                   return controller.isFinishedHeading.value
                //                       ? Center(
                //                           child: AnimatedTextKit(
                //                             isRepeatingAnimation: false,
                //                             onFinished: () => controller.onFinished(),
                //                             animatedTexts: <AnimatedText>[
                //                               TypewriterAnimatedText(
                //                                 '''
                // Get ready for a chance to win big!\nwe're excited to announce that once we reach 10,000 users, we'll be conducting a lucky draw contest.\nstay tuned for more information on how to participate and the prizes you can win.\nin the meantime, invite your friends and family to join the app and increase your chances of being one of the lucky winners.

                // If you have a beloved one who dreams of exploring these breathtaking locations but is unable to do so due to financial limitations, we invite you to recommend them to TourMaker's suugestion screen (which appears next).simply provide us with their contact information . Our team will carefully reviewand verify all submissions and select deserving individuals for the free tour packages.
                // Let's come together and make dreams come true! Nominate your beloved one now and let them experience the wonders of Kashmir or Manali without worrying about finances.
                // \n LET'S REACH OUR GOAL TOGETHER!''',
                //                                 speed: const Duration(milliseconds: 50),
                //                                 textAlign: TextAlign.justify,
                //                                 textStyle: heading2.copyWith(
                //                                   leadingDistribution:
                //                                       TextLeadingDistribution.even,
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         )
                //                       : const SizedBox();
                //                 }),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: Obx(
      //   () {
      //     return controller.isFinished.value
      //         ? showFloatingButton()
      //         : Container();
      //   },
      // ),
    );
  }

  Card buildLuckyDrawCard() {
    return Card(
      color: Colors.transparent,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            Text('Lucky Draw Contest', style: heading3),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                '''LUCKY DRAW WILL BE CONDUCTED ONLY AFTER 10k APP INSTALLATION.\n\nIF YOU CAN BOOK MINIMUM 2 TOURS WITHIN 20 DAYS OF YOUR APP INSTALLATION YOU WILL GET BACK 425 RS. fROM YOUR SERVICE CHARGE(500RS) AFTER DEDUCTING THE Tax AMOUNT.''',
                textAlign: TextAlign.justify,
                style: subheading3.copyWith(),
              ),
            ),
            const SizedBox(height: 30),
            Obx(() {
              return CustomButton().showButtonWithGradient(
                  isLoading: controller.isLoading.value,
                  text: 'Next',
                  onPressed: () => controller.onClickNext());
            })
          ],
        ),
      ),
    );
  }

  Widget showFloatingButton() => FloatingActionButton(
        backgroundColor: englishViolet,
        onPressed: () => controller.onClickFoatingButton(),
        child: const Icon(Icons.arrow_forward),
      );

  AnimatedContainer buildSuggestAFriend() => AnimatedContainer(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 600),
        child: Card(
          color: Colors.transparent,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 100.w,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                Text('Suggest A friend', style: heading3),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    '''
If you have a loved one who wishes to visit these gorgeous sites but is unable to do so due to budgetary constraints, please recommend them to TourMaker.Simply give us their contact information. Our team will carefully analyse and verify all submissions before selecting individuals deserving of free tour packages.\n\n
Let us work together to make our aspirations a reality! Nominate your loved one immediately and let them enjoy the beauties of Kashmir or Manali without having to worry about money.
''',
                    textAlign: TextAlign.justify,
                    style: subheading3.copyWith(),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  return CustomButton().showButtonWithGradient(
                      isLoading: controller.isloading.value,
                      text: 'Suggest A friend',
                      onPressed: () => controller.onClickFoatingButton());
                })
              ],
            ),
          ),
        ),
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

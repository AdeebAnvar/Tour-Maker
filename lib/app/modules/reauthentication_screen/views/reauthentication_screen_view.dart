import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../core/theme/style.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../controllers/reauthentication_screen_controller.dart';

class ReauthenticationScreenView
    extends GetView<ReauthenticationScreenController> {
  const ReauthenticationScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final ReauthenticationScreenController controller =
        Get.put(ReauthenticationScreenController());
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(),
        body: controller.obx(
          onLoading: const CustomLoadingScreen(),
          (dynamic state) => Padding(
            padding: const EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Enter 6 Digit Code', style: heading2),
                  const SizedBox(height: 12),
                  Text(
                    'Enter the OTP send to  ${controller.phone} ',
                    style: subheading3,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 17),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: PinFieldAutoFill(
                        decoration: BoxLooseDecoration(
                            strokeColorBuilder: FixedColorBuilder(fontColor)),
                        controller: controller.textEditorController,
                        onCodeSubmitted: (String code) {
                          log('code submitted');
                        },
                        currentCode: controller.otpCode.value,
                        onCodeChanged: (String? code) async {
                          log('code changed');
                          controller.otpCode.value = code!;
                          if (controller.textEditorController.text.length ==
                              6) {
                            log('adeeb sign in auto fill text field');
                            await controller.authenticate();
                            controller.countDownController.pause();
                          }
                          controller.countDownController.pause();
                          // await controller.signIn();
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                  Countdown(
                    seconds: 60,
                    build: (BuildContext context, double currentRemainingtime) {
                      if (currentRemainingtime == 0.0) {
                        return GestureDetector(
                          onTap: () => controller.onResendinOTP(),
                          child: Text('Resend OTP ', style: subheading3),
                        );
                      } else {
                        return Text(
                          "Trying to automatically get OTP in ${currentRemainingtime.toString().length == 4 ? " ${currentRemainingtime.toString().substring(0, 2)}" : " ${currentRemainingtime.toString().substring(0, 1)} seconds"}",
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return CustomButton().showIconButtonWithGradient(
                      height: 72,
                      isLoading: controller.isLoading.value,
                      width: 100.w,
                      text: '             verify',
                      onPressed: () => controller.authenticate(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ));
  }
}

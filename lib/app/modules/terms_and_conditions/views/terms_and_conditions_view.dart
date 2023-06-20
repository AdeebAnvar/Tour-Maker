import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../controllers/terms_and_conditions_controller.dart';

class TermsAndConditionsView extends GetView<TermsAndConditionsController> {
  const TermsAndConditionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Image.asset('assets/Accept illustration.png'),
              const SizedBox(height: 30),
              Text('Terms & Conditions', style: heading2),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Text(controller.termsAndCond, style: paragraph4),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: <Widget>[
                    Obx(() {
                      return Checkbox(
                        value: controller.ischecked.value,
                        onChanged: (bool? value) => controller.onCheck(value!),
                        activeColor: englishViolet,
                      );
                    }),
                    Text(
                      'By clicking here, I state that I have read \nand understood the terms and conditions.',
                      style: TextStyle(
                        // fontFamily: montserratRegular,
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => controller.isButtonVisisble.value
                    ? CustomButton().showButtonWithGradient(
                        isLoading: controller.isLoading.value,
                        width: controller.isLoading.value ? 50 : 280,
                        height: 70,
                        text: "Let's Get Started",
                        onPressed: () => controller.onGetStartedClicked(),
                      )
                    : CustomButton().showButton(
                        width: 280,
                        height: 70,
                        bgColor: Colors.grey,
                        text: "Let's Get Started",
                        onPressed: () {},
                      ),
              ),
              GestureDetector(
                onTap: ()=>controller.onTapViewMore(),
                child: Text('view more > > >',style: subheading3.copyWith(color: englishlinearViolet,),),)
            ],
          ),
        ),
      ),
    );
  }
}

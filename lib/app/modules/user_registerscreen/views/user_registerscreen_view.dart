import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/custom_textformfield.dart';
import '../controllers/user_registerscreen_controller.dart';

class UserRegisterscreenView extends GetView<UserRegisterscreenController> {
  const UserRegisterscreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final UserRegisterscreenController controller =
        Get.put(UserRegisterscreenController());
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(),
        resizeToAvoidBottomInset: true,
        body: controller.obx(
          onLoading: const CustomLoadingScreen(),
          (UserRegisterscreenView? state) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Register',
                    style: heading1,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add more about yourself',
                    style: subheading1,
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextFormField(
                            keyboardType: TextInputType.name,
                            prefixIcon:
                                Icon(TourMaker.profile_icon, color: fontColor),
                            hintText: 'Name',
                            validator: (String? value) =>
                                controller.nameValidator(value),
                            onChanged: (String value) =>
                                controller.userName.value = value,
                            initialValue: controller.userName.value,
                          ),
                          const SizedBox(height: 15),
                          CustomTextFormField(
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              TourMaker.email_icon,
                              color: fontColor,
                            ),
                            hintText: 'Email',
                            validator: (String? value) =>
                                controller.emailValidator(value),
                            onChanged: (String value) {
                              controller.userEmail.value = value;
                            },
                            initialValue: controller.userEmail.value,
                          ),
                          const SizedBox(height: 15),
                          CustomTextFormField(
                              keyboardType: TextInputType.phone,
                              hintText: 'Phone Number',
                              validator: (String? value) =>
                                  controller.phoneNumberValidator(value),
                              onChanged: (String? value) =>
                                  controller.userPhone.value = value.toString(),
                              initialValue: controller.userPhone.value,
                              prefixIcon:
                                  Icon(TourMaker.call, color: fontColor)),
                          const SizedBox(height: 15),
                          Obx(() {
                            return ActionChip(
                              backgroundColor: englishViolet,
                              onPressed: () => controller.getAddressofUser(),
                              label: controller.isFindingAddressOfUser.value
                                  ? Row(
                                      children: <Widget>[
                                        Text(
                                          'Click to automatically find you!',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Spacer(),
                                        const SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                        const SizedBox()
                                      ],
                                    )
                                  : Text(
                                      'Click to automatically find you!',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                      ),
                                    ),
                            );
                          }),
                          const SizedBox(height: 15),
                          Obx(() {
                            return CustomTextFormField(
                              // controller: TextEditingController(
                              //     text: controller.userAddress.value),
                              // maxLines: 10,
                              // minLines: 1,
                              validator: (String? value) =>
                                  controller.addressValidator(value),
                              onChanged: (String? value) => controller
                                  .userAddress.value = value.toString(),
                              hintText: 'Address',
                              initialValue: controller.userAddress.value,
                            );
                          }),
                          const SizedBox(height: 15),
                          Obx(() {
                            return CustomTextFormField(
                              controller: TextEditingController(
                                  text: controller.userCountry.value),
                              validator: (String? value) {
                                return null;
                              },
                              enabled: false,
                              onChanged: (String? value) => controller
                                  .userCountry.value = value.toString(),
                              hintText: 'Country',
                              // initialValue: controller.userCountry.value,
                            );
                          }),
                          const SizedBox(height: 15),
                          Obx(() {
                            return CustomTextFormField(
                              controller: TextEditingController(
                                  text: controller.userState.value),
                              validator: (String? value) {
                                return null;
                              },
                              enabled: false,
                              onChanged: (String? value) =>
                                  controller.userState.value = value.toString(),
                              hintText: 'State',
                              // initialValue: controller.userState.value,
                            );
                          }),
                          const SizedBox(height: 15),
                          Obx(() {
                            return CustomTextFormField(
                              controller: TextEditingController(
                                  text: controller.userCity.value),
                              validator: (String? value) {
                                return null;
                              },
                              enabled: false,
                              onChanged: (String? value) =>
                                  controller.userCity.value = value.toString(),
                              hintText: 'district',
                              // initialValue: controller.userCity.value,
                            );
                          }),
                          const SizedBox(height: 15),
                          Obx(() {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 232, 231, 233),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButton<Gender>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: controller.selectedGender.value,
                                onChanged: (Gender? newValue) {
                                  controller.selectedGender.value = newValue!;
                                },
                                hint: const Text('Select Gender'),
                                items: Gender.values.map((Gender gender) {
                                  return DropdownMenuItem<Gender>(
                                    value: gender,
                                    child:
                                        Text(gender.toString().split('.').last),
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                          const SizedBox(height: 15),
                          Obx(() {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 232, 231, 233),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButton<CategoryType>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: controller.selectedCategoryType.value,
                                onChanged: (CategoryType? newValue) {
                                  controller.selectedCategoryType.value =
                                      newValue!;
                                  if (controller.selectedCategoryType.value ==
                                      CategoryType.standard) {
                                    log('sfg');
                                  } else {
                                    controller.payAmount();
                                  }
                                },
                                hint: const Text('Select Category'),
                                items: CategoryType.values
                                    .map((CategoryType categoryType) {
                                  return DropdownMenuItem<CategoryType>(
                                    value: categoryType,
                                    child: Text(categoryType
                                        .toString()
                                        .split('.')
                                        .last),
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    onChanged: (String value) =>
                        controller.usereEnterpriseName.value = value,
                    validator: (String? value) {
                      return null;
                    },
                    initialValue: controller.usereEnterpriseName.value,
                    hintText: 'Enterprise Name(Optional)',
                  ),
                  const SizedBox(height: 15),
                  Obx(() {
                    return CustomButton().showIconButtonWithGradient(
                      height: 75,
                      width: 100.h,
                      isLoading: controller.isloading.value,
                      text: '     Submit',
                      onPressed: () => controller.onRegisterClicked(),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

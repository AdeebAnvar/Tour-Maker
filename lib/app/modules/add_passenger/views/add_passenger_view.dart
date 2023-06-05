import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/custom_textformfield.dart';
import '../../../widgets/customdatepicker.dart';
import '../../../widgets/passenger_card.dart';
import '../controllers/add_passenger_controller.dart';

class AddPassengerView extends GetView<AddPassengerController> {
  const AddPassengerView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: const CustomAppBar(),
            resizeToAvoidBottomInset: true,
            body: controller.obx(
              onEmpty: const CustomErrorScreen(
                errorText: 'Please Add \nPassengers Details',
              ),
              onLoading: const CustomLoadingScreen(),
              (AddPassengerView? state) => Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Text(
                    'Travellers',
                    style: heading2,
                  ),
                  Text(
                    '${controller.travellers.length}/${controller.totalTravellers} passengers added',
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () {
                      return controller.travellers.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.travellers.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        GestureDetector(
                                  onTap: () => controller.onTapSinglePassenger(
                                      controller.travellers[0].id),
                                  child: PassengerCard(
                                    travellers: controller.travellers[index],
                                  ),
                                ),
                              ),
                            )
                          : const Expanded(
                              child: CustomErrorScreen(
                                errorText: 'Please Add \nPassengers Details',
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                controller.totalTravellers == controller.travellers.length
                    ? FloatingActionButtonLocation.centerFloat
                    : FloatingActionButtonLocation.endFloat,
            floatingActionButton: controller.totalTravellers ==
                    controller.travellers.length
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.bounceInOut,
                    child: FloatingActionButton.extended(
                      onPressed: () => controller.gotoCheckoutPage(),
                      backgroundColor: englishViolet,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: controller.isLoadingIc.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Ready to checkout'),
                    ),
                  )
                : FloatingActionButton(
                    onPressed: () => showAddPassengerDialogue(context),
                    backgroundColor: englishViolet,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: const Icon(Icons.add),
                  ),
          );
        },
      ),
    );
  }

  Future<dynamic> showAddPassengerDialogue(BuildContext context) {
    return Get.bottomSheet(
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 10,
      enterBottomSheetDuration: const Duration(milliseconds: 500),
      exitBottomSheetDuration: const Duration(milliseconds: 500),
      Material(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      )
                    ],
                  ),
                  CustomTextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    onChanged: (String? value) =>
                        controller.customerName.value = value.toString(),
                    validator: (String? value) =>
                        controller.nameValidator(value),
                    hintText: 'Name',
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onChanged: (String? value) =>
                        controller.customerPhone.value = value.toString(),
                    validator: (String? value) =>
                        controller.phoneNumberValidator(value),
                    hintText: 'Phone Number',
                  ),
                  const SizedBox(height: 15),
                  CustomDatePickerField(
                    isTime: true,
                    labelName: 'Date Of Birth',
                    validator: (String? value) =>
                        controller.dobValidator(value),
                    onChange: (String value) =>
                        controller.customerDOB.value = value,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    textInputAction: TextInputAction.done,
                    maxLines: 10,
                    minLines: 1,
                    validator: (String? value) =>
                        controller.addressValidator(value),
                    onChanged: (String? value) =>
                        controller.customerAddress.value = value.toString(),
                    hintText: 'Address',
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 231, 233),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Obx(
                      () => controller.image.value != ''
                          ? Column(
                              children: <Widget>[
                                Text('ID proof', style: subheading2),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  margin: const EdgeInsets.all(10),
                                  child: Image.file(
                                    fit: BoxFit.cover,
                                    File(controller.image.value),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(Icons.camera_alt),
                                      onPressed: () {
                                        onClickCamera(context);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text('      ID PROOF'),
                                IconButton(
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: () {
                                    onClickCamera(context);
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () {
                      return CustomButton().showIconButtonWithGradient(
                        height: 75,
                        width: 100.h,
                        isLoading: controller.isloading.value,
                        text: '      Submit',
                        onPressed: () => controller.onRegisterClicked(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> onClickCamera(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Choose profile pic from :'),
          content: Container(
            padding: const EdgeInsets.all(8),
            height: 140,
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.image, color: englishViolet),
                    title: const Text('Gallery'),
                    onTap: () {
                      controller.getImage(ImageSource.gallery);
                      Get.back();
                    }),
                ListTile(
                    leading:
                        Icon(Icons.camera_alt_rounded, color: englishViolet),
                    title: const Text('Camera'),
                    onTap: () {
                      controller.getImage(ImageSource.camera);
                      Get.back();
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}

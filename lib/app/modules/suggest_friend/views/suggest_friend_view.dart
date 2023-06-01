import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_textformfield.dart';
import '../controllers/suggest_friend_controller.dart';

class SuggestFriendView extends GetView<SuggestFriendController> {
  const SuggestFriendView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Suggest A friend'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: <Widget>[
                CustomTextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  onChanged: (String? value) =>
                      controller.name.value = value.toString(),
                  validator: (String? value) => controller.nameValidator(value),
                  hintText: 'Name',
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onChanged: (String? value) =>
                      controller.phone.value = value.toString(),
                  validator: (String? value) =>
                      controller.phoneNumberValidator(value),
                  hintText: 'Phone Number',
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.done,
                  maxLines: 10,
                  minLines: 1,
                  validator: (String? value) =>
                      controller.addressValidator(value),
                  onChanged: (String? value) =>
                      controller.address.value = value.toString(),
                  hintText: 'Address',
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (String? value) =>
                      controller.state.value = value.toString(),
                  validator: (String? value) =>
                      controller.stateValidator(value),
                  hintText: 'State',
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  onChanged: (String? value) =>
                      controller.district.value = value.toString(),
                  validator: (String? value) =>
                      controller.districtValidator(value),
                  hintText: 'District',
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  onChanged: (String? value) =>
                      controller.country.value = value.toString(),
                  validator: (String? value) =>
                      controller.countryValidator(value),
                  hintText: 'Country',
                ),
                const SizedBox(height: 5),
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
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.HOME);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: englishlinearViolet,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/style.dart';

import '../../../data/models/network_models/order_payment_model.dart';
import '../../../data/models/network_models/travellers_model.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/add_passenger_view.dart';

class AddPassengerController extends GetxController
    with StateMixin<AddPassengerView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  final TextEditingController controller = TextEditingController();
  final DateTime selectedDate = DateTime.now();
  int? orderID;
  int? totalTravellers;
  Rx<OrderPaymentModel> orderPaymentModel = OrderPaymentModel().obs;
  RxList<TravellersModel> travellers = <TravellersModel>[].obs;
  RxBool isloading = false.obs;
  Rx<bool> isLoadingIc = false.obs;
  RxString image = ''.obs;
  Rx<String> customerAddress = ''.obs;
  Rx<String> customerName = ''.obs;
  Rx<String> customerPhone = ''.obs;
  Rx<String> customerAdhaar = ''.obs;
  Rx<String> customerDOB = ''.obs;
  @override
  void onInit() {
    super.onInit();
    // Load the datas from previous screen (Single tour Screen)
    loadData();
  }

// validate DOB which entered by user is valid or not
  String? dobValidator(String? value) => DateTime.tryParse(value ?? '') != null
      ? null
      : 'Please enter a valid DOB';
  //  validate name of passenger which entered by user is valid or not
  String? nameValidator(String? value) => GetUtils.isLengthLessOrEqual(value, 3)
      ? 'Please enter a valid name'
      : null;
  //  validate phone number which entered by user is valid or not
  String? phoneNumberValidator(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 9)
          ? 'Please enter a valid phone number'
          : null;
  //  validate address which entered by user is valid or not
  String? addressValidator(String? value) =>
      GetUtils.isLengthGreaterOrEqual(value, 10)
          ? null
          : 'please enter a valid address';

  void loadData() {
    // checking the arguments is null or not from the previous screen

    if (Get.arguments != null) {
      change(null, status: RxStatus.loading());
      orderID = Get.arguments[0] as int;
      totalTravellers = Get.arguments[1] as int;
      change(null, status: RxStatus.success());
    }
  }

// After adding the passenger details on bottomsheet . we need to check the datas
// and also validate the datas and send to server
  Future<void> onRegisterClicked() async {
    if (formKey.currentState!.validate()) {
      // if the form state is validated after that check the id proof image is added or not
      // if (image.value != '') {
      // when it added send the data to server
      isloading.value = true;
      final ApiResponse<bool> res = await PassengerRepository().addpassenger(
        customerName.value,
        customerPhone.value,
        orderID.toString(),
        customerDOB.value,
        customerAddress.value,
        // image.value,
      );
      if (res.status == ApiResponseStatus.completed) {
        image.value = '';
        // After the data's added close the bottom sheet
        await getTravellers(orderID).whenComplete(() => Get.back());
      } else {
        // when the data can't be added shows this dialogue
        CustomDialog().showCustomDialog("Can't add the passenger",
            contentText: 'Please check the all details that you entered');
      }
      isloading.value = false;
      // } else {
      //   // when the id proof is n't added show the snackbar
      //   Get.snackbar('Add your ID proof', 'Add any ID proof',
      //       backgroundColor: englishViolet, colorText: Colors.white);
      // }
    }
    isloading.value = false;
  }

  // GetImage function get the image from outside of the app
  Future<void> getImage(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      image.value = pickedFile.path;
    }
  }

  // getting the travellers from the sevrer to visible on initials screen
  Future<void> getTravellers(int? orderID) async {
    final ApiResponse<List<TravellersModel>> res =
        await PassengerRepository().getAllPassengersByOrderId(orderID!);
    if (res.data != null) {
      travellers.value = res.data!;
    } else {}
  }

  // After completing the traveller details navigate to checkout screen
  void gotoCheckoutPage() {
    isLoadingIc.value = true;
    CustomDialog().showCustomDialog('Are your Ready \nto checkout',
        contentText:
            "Please double check \n the data's you entered\n before checkout",
        cancelText: 'Go back', onCancel: () {
      Get.back();
      isLoadingIc.value = false;
    }, onConfirm: () {
      Get.back();
      Get.offAllNamed(Routes.CHECKOUT_SCREEN);
      isLoadingIc.value = false;
    });
    isLoadingIc.value = false;
  }

  void onTapSinglePassenger(int? id) {
    Get.toNamed(Routes.SINGLE_PASSENGER, arguments: id);
  }
}

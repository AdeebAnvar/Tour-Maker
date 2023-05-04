import 'dart:convert';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../core/theme/style.dart';

import '../../../data/models/network_models/razorpay_model.dart';
import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/razorpay_repo.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/profile_view.dart';

class ProfileController extends GetxController with StateMixin<ProfileView> {
  late Razorpay razorPay;
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
  final ImagePicker picker = ImagePicker();
  String? username;
  String? base64Image;
  int? amount;
  Rx<bool> showUserPic = false.obs;
  RxBool isloading = false.obs;
  RxBool isShowButton = true.obs;
  Rx<String> address = ''.obs;
  Rx<String> image = 'assets/Avatar.png'.obs;
  Rx<UserModel> userData = UserModel().obs;
  Rx<RazorPayModel> razorPayModel = RazorPayModel().obs;
  UserRepository userRepo = UserRepository();
  @override
  void onInit() {
    super.onInit();
    getData();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorPay.clear();
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    final ApiResponse<UserModel> res = await userRepo.getUserDetails();
    if (res.status == ApiResponseStatus.completed && res.data != null) {
      userData.value = res.data!;
      username = userData.value.name;
      if (userData.value.profileImage != '') {
        showUserPic.value = true;
      } else {
        showUserPic.value = false;
      }
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final String? signature = response.signature;
    final String? orderId = razorPayModel.value.packageId;
    final String? paymentId = response.paymentId;
    final ApiResponse<bool> res = await RazorPayRepository()
        .verifyOrderPayment(paymentId, signature, orderId);
    try {
      if (res.status == ApiResponseStatus.completed && res.data!) {
        showRegisterBttomSheet(
            userData.value.name.toString(),
            userData.value.state.toString(),
            userData.value.phoneNumber.toString());
      } else {}
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', e.toString());
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomDialog().showCustomDialog(
        'Payment error: ${response.code}', '${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CustomDialog()
        .showCustomDialog('Payment successed: ', 'on : ${response.walletName}');
  }

  Future<void> onClickPayment() async {
    isloading.value = true;

    final RazorPayModel razorPaymodel = RazorPayModel(
      amount: 1000,
      contact: userData.value.phoneNumber,
      currency: 'INR',
      name: userData.value.name,
    );
    final ApiResponse<RazorPayModel> res =
        await RazorPayRepository().createPayment(razorPaymodel);
    try {
      if (res.data != null) {
        razorPayModel.value = res.data!;
        openRazorPay(razorPayModel.value.packageId.toString());
      } else {}
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', e.toString());
    }
    isloading.value = false;
  }

  Future<void> openRazorPay(String orderId) async {
    final Map<String, Object?> options = <String, Object?>{
      'key': 'rzp_test_yAFypxWUiCD7H7',
      'name': userData.value.name,
      'description': 'Test Payment',
      'order_id': orderId,
      'prefill': <String, Object?>{
        'contact': userData.value.phoneNumber,
      },
      'external': <String, Object?>{
        'wallets': <String>[
          'paytm',
          'freecharge',
          'mobikwik',
          'jiomoney',
          'airtelmoney',
          'payzapp',
          'olamoney',
          'phonepe',
          'amazonpay',
          'googlepay'
        ],
      },
    };

    try {
      razorPay.open(options);
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', e.toString());
    }
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
          source: source, imageQuality: 50, maxHeight: 500, maxWidth: 500);

      if (pickedFile != null) {
        final String fileName = pickedFile.path.split('/').last;

        final ApiResponse<Map<String, dynamic>> res =
            await userRepo.addUserProfilePic(fileName, pickedFile.path);
        if (res.status == ApiResponseStatus.completed) {
          // handle success
          Get.snackbar(
            'Profile pic added successfully!!!',
            'Please refresh the page',
            backgroundColor: englishViolet,
            colorText: Colors.white,
          );
        } else {
          // handle error
        }
      } else {
        // user did not pick an image
        Get.snackbar('No image Selected', 'Please add you pic',
            backgroundColor: englishViolet, colorText: Colors.white);
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', e.toString());
    }
  }

  void showRegisterBttomSheet(String name, String state, String phoneNumber) {
    Get.toNamed(Routes.USER_REGISTERSCREEN)!.whenComplete(() => getData());
  }

  Uint8List getImageFromBytes() {
    final String base64Image = userData.value.profileImage!;
    final Uint8List bytes = base64.decode(base64Image.split(',').last);
    return bytes;
  }

  void onClickAdddetail() {
    Get.toNamed(Routes.USER_REGISTERSCREEN)!.whenComplete(() => getData());
  }
}

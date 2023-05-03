import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/network_models/razorpay_model.dart';
import '../../../data/models/network_models/single_payment_model.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../data/repo/network_repo/payment_repo.dart';
import '../../../data/repo/network_repo/razorpay_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../views/payment_summary_view.dart';

class PaymentSummaryController extends GetxController
    with StateMixin<PaymentSummaryView> {
  RxList<SinglePaymentModel> paymentList = <SinglePaymentModel>[].obs;
  Rx<bool> isLoading = false.obs;
  Rx<OrderPaymentModel> orderPaymentModel = OrderPaymentModel().obs;
  late Razorpay razorPay;
  int? id;
  @override
  void onInit() {
    super.onInit();
    loadData();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void loadData() {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      id = Get.arguments as int;
      log('sfg $id');
      loadPaymentDetails(id!);
    }
  }

  Future<void> loadPaymentDetails(int id) async {
    final ApiResponse<List<SinglePaymentModel>> res =
        await PaymentRepository().getSinglePayment(id);
    log('payment details ${res.message}');
    if (res.data != null) {
      paymentList.value = res.data!;
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  int getTotalTravellersCount() {
    final int sum = paymentList[0].noOfAdults! + paymentList[0].noOfKids!;
    return sum;
  }

  num getRemainingAmount() {
    final num sum = paymentList[0].payableAmount! - paymentList[0].amountPaid!;
    return sum;
  }

  void onClickPassengers(int? id) {
    Get.toNamed(Routes.TRAVELLERS_SCREEN, arguments: id)!
        .whenComplete(() => loadData());
  }

  Future<void> onClickPayRemainingAmount(int id) async {
    log('Payment pay full amount id $id');
    //CreatePayment
    orderPaymentModel.value = await createPayment(id);
    log('Payment pay full amount orderPayment ${orderPaymentModel.value.id}');
    log('kunukunu ${orderPaymentModel.value}');
    // //open razorpay
    openRazorPay(orderPaymentModel.value.id.toString());
  }

  Future<OrderPaymentModel> createPayment(int iD) async {
    log('Payment xcreate $iD');
    final OrderPaymentModel omp =
        OrderPaymentModel(orderId: iD, currency: 'INR');

    try {
      final ApiResponse<OrderPaymentModel> res =
          await PassengerRepository().createRemainingAmountPayment(omp);
      log('dsgaefv d ms${res.message}');
      log('dsgaefv d ${res.data}');
      log('dsgaefv d ${res.status}');

      if (res.data != null) {
        orderPaymentModel.value = res.data!;
      } else {
        // log(' adeeb raz emp ');
      }
    } catch (e) {
      log('raz catch $e');
    }
    return orderPaymentModel.value;
  }

  void openRazorPay(String paymentID) {
    log('Payment openRazorPay $paymentID');
    final Map<String, Object?> options = <String, Object?>{
      'key': 'rzp_test_yAFypxWUiCD7H7',
      'name': 'TourMaker',
      'description': 'Pay for your Package Order',
      'order_id': paymentID,
      'external': <String, Object?>{
        'wallets': <String>['paytm'],
      },
    };
    log('adeeb anvar $options');

    try {
      razorPay.open(options);
      log('adeeb anvar raz op');
    } catch (e) {
      log('kunukunu error op $e');
      log('Error opening Razorpay checkout: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final String? signature = response.signature;
    final String? orderId = orderPaymentModel.value.id;
    final String? paymentId = response.paymentId;
    log('Payment bbddibdi sing $signature');
    log('Payment bbddibdi id $orderId');
    log('Payment bbddibdi payid $paymentId');

    final ApiResponse<bool> res = await RazorPayRepository()
        .verifyOrderPayment(paymentId, signature, orderId);
    try {
      if (res.status == ApiResponseStatus.completed && res.data!) {
        log('kunukunu completed payment fro the tour');
        Get.offAllNamed(
          Routes.HOME,
        )!
            .then(
          (dynamic value) => Get.snackbar(
            'Success ',
            'Payment Suucess for the tour ${paymentList[0].tourName}',
            backgroundColor: englishViolet,
            colorText: Colors.white,
          ),
        );
      } else {
        log('kunukunu Payment verification failed: ${res.message}');
      }
    } catch (e) {
      log('kunukunu Error while handling payment success: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Payment error: ${response.code}', '${response.message}');
    log('kunukunu Payment error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('Payment successed: ', 'on : ${response.walletName}');

    log('External wallet: ${response.walletName}');
  }

  num getPackageGSTamount(num totalAmount, num gst) {
    final num gstAmount = (totalAmount * gst) / 100;
    return gstAmount;
  }
}

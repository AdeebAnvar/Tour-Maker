import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/utils/constants.dart';
import '../../../data/models/local_model/checkout_model.dart';
import '../../../data/models/network_models/razorpay_model.dart';
import '../../../data/repo/local_repo/checkout_repo.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../data/repo/network_repo/razorpay_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/checkout_screen_view.dart';

class CheckoutScreenController extends GetxController
    with StateMixin<CheckoutScreenView> {
  Rx<CheckOutModel?> checkOutModel = Rx<CheckOutModel?>(null);
  Rx<OrderPaymentModel> orderPaymentModel = OrderPaymentModel().obs;
  Rx<OrderPaymentModel> orderAdvPaymentModel = OrderPaymentModel().obs;
  late Razorpay razorPay;
  // Rx<RazorPayModel> razorPayModel = RazorPayModel().obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    try {
      checkOutModel.value = await CheckOutRepositoy.getData();
      final int? orderID = checkOutModel.value!.orderID;
      log('bfhvb $orderID');
      change(null, status: RxStatus.success());
    } catch (e) {
      log('error loading data $e');
    }
  }

  num getTotalAmount() {
    final int adultCount = checkOutModel.value!.adultCount!;
    final int chidrenCount = checkOutModel.value!.childrenCount!;
    final num adultAmount = checkOutModel.value!.offerAmount != 0
        ? checkOutModel.value!.offerAmount! * adultCount
        : checkOutModel.value!.amount! * adultCount;
    final num kidsAmount = checkOutModel.value!.kidsOfferAmount != 0
        ? checkOutModel.value!.kidsOfferAmount! * chidrenCount
        : checkOutModel.value!.kidsAmount! * chidrenCount;
    final num totalAmount = adultAmount + kidsAmount;
    return totalAmount;
  }

  double getGST() {
    final num totalAmount = getTotalAmounttoBePaid();
    final double gst = (totalAmount * checkOutModel.value!.gst!) / 100;
    return gst;
  }

  double getSGST() {
    final num totalAmount = getTotalAmounttoBePaid();
    final double sgstpercentage = checkOutModel.value!.gst! / 2;
    final double sgst = (totalAmount * sgstpercentage) / 100;
    return sgst;
  }

  double getCGST() {
    final num totalAmount = getTotalAmounttoBePaid();
    final double cgstPercentage = checkOutModel.value!.gst! / 2;
    final double sgst = (totalAmount * cgstPercentage) / 100;
    return sgst;
  }

  num getTotalAmounttoBePaid() {
    final num commissionAmount = getCommissionAmount();
    final num totalAmount = getTotalAmount();
    final num sum;
    currentUserCategory == 'standard'
        ? sum = totalAmount
        : sum = totalAmount - commissionAmount;
    return sum;
  }

  num getCommissionAmount() {
    final num commission = checkOutModel.value!.commission!;
    final int totalPassenegrs = getTotalPassengers();
    final num sum = commission * totalPassenegrs;
    return sum;
  }

  int getTotalPassengers() {
    final int totalPassenegrs =
        checkOutModel.value!.adultCount! + checkOutModel.value!.childrenCount!;
    return totalPassenegrs;
  }

  num getGrandTotal() {
    final num gst = getGST();
    final num totalAmount = getTotalAmounttoBePaid();
    final num grandTotal = totalAmount + gst;
    return grandTotal;
  }

  void onViewItinerary(String? tourItinerary) {
    Get.toNamed(Routes.PDF_VIEW, arguments: <String>[tourItinerary!]);
  }

  void onClickCancelPurchase() {
    CustomDialog().showCustomDialog(
      'Are You Sure?',
      'Do you want to really cancel the purchase?',
      cancelText: 'go back',
      confirmText: 'Yes',
      onCancel: () {
        Get.back();
      },
      onConfirm: () {
        Get.offAllNamed(Routes.HOME);
      },
    );
  }

  void onClickconfirmPurchase(int id) {
    CustomDialog().showCustomDialog(
      'Total amount ${getGrandTotal().toStringAsFixed(2)}',
      'Advance amount ${checkOutModel.value!.advanceAmount} + GST(${checkOutModel.value!.gst}%)',
      cancelText: 'Pay Advance Amount',
      confirmText: 'Pay Full Amount',
      onCancel: () {
        payAdvanceAmount(id);
      },
      onConfirm: () {
        payFullAmount(id);
      },
    );
  }

  void onViewPasengers(int? orderiD) {
    Get.toNamed(Routes.TRAVELLERS_SCREEN, arguments: orderiD)!
        .whenComplete(() => loadData());
  }

  Future<void> payAdvanceAmount(int id) async {
    log('Payment pay adv amount id $id');
    //CreatePayment
    orderAdvPaymentModel.value = await createAdvancePayment(id);
    log('Payment pay adv amount orderPayment ${orderPaymentModel.value.id}');
    log('kunukunu ${orderPaymentModel.value}');
    // //open razorpay
    openRazorPay(orderAdvPaymentModel.value.id.toString());
  }

  Future<void> payFullAmount(int id) async {
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
    final OrderPaymentModel omp = OrderPaymentModel(
      orderId: iD,
      currency: 'INR',
    );

    try {
      final ApiResponse<OrderPaymentModel> res =
          await PassengerRepository().createPayment(omp);
      log('dsgaefv d ${res.status}');
      log('dsgaefv d ms${res.message}');
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

  Future<OrderPaymentModel> createAdvancePayment(int iD) async {
    log('kunukunu xcreate ');
    final OrderPaymentModel omp = OrderPaymentModel(
      orderId: iD,
      currency: 'INR',
    );

    try {
      final ApiResponse<OrderPaymentModel> res =
          await PassengerRepository().createAdvancePayment(omp);
      if (res.data != null) {
        orderAdvPaymentModel.value = res.data!;
      } else {
        // log(' adeeb raz emp ');
      }
    } catch (e) {
      log('raz catch $e');
    }
    return orderAdvPaymentModel.value;
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
    final String? orderId;
    if (orderPaymentModel.value.id == null) {
      orderId = orderAdvPaymentModel.value.id;
    } else {
      orderId = orderPaymentModel.value.id;
    }
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
          (value) => Get.snackbar(
            'Success ',
            'Payment Suucess for the tour ${checkOutModel.value!.tourName}',
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
    Get.snackbar('kunukunu Payment successed: ', 'on : ${response.walletName}');

    log('External wallet: ${response.walletName}');
  }
}

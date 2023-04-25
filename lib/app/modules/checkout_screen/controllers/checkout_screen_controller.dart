import 'dart:developer';

import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
  late Razorpay razorPay;
  Rx<RazorPayModel> razorPayModel = RazorPayModel().obs;
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
    final num adultAmount = checkOutModel.value!.offerAmount != null
        ? checkOutModel.value!.offerAmount! * adultCount
        : checkOutModel.value!.amount! * adultCount;
    final num kidsAmount = checkOutModel.value!.kidsOfferAmount != null
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
    currentUserCategory == 'Standard User'
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
        Get.toNamed(Routes.SINGLE_TOUR,
            arguments: <dynamic>[checkOutModel.value!.tourID]);
      },
    );
  }

  void onClickconfirmPurchase(int id) {
    CustomDialog().showCustomDialog(
      'Total amount ${getGrandTotal().toStringAsFixed(2)}',
      'Advance amount ${checkOutModel.value!.advanceAmount}',
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

  void payAdvanceAmount(int id) {}

  Future<void> payFullAmount(int id) async {
    //CreatePayment
    orderPaymentModel.value = await createPayment(id);
    log('kunukunu ${orderPaymentModel.value}');
    // //open razorpay
    openRazorPay(orderPaymentModel.value.id.toString());
  }

  Future<OrderPaymentModel> createPayment(int iD) async {
    log('kunukunu xcreate ');
    final OrderPaymentModel omp = OrderPaymentModel(
      orderId: iD,
      currency: 'INR',
    );

    try {
      final ApiResponse<OrderPaymentModel> res =
          await PassengerRepository().createPayment(omp);
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
    log('kunukunu $paymentID');
    final Map<String, Object?> options = <String, Object?>{
      'key': 'rzp_test_yAFypxWUiCD7H7',
      'name': 'TourMaker App',
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
    final String? orderId = razorPayModel.value.packageId;
    final String? paymentId = response.paymentId;
    log('bbddibdi sing $signature');
    log('bbddibdi id $orderId');
    log('bbddibdi payid $paymentId');

    final ApiResponse<bool> res = await RazorPayRepository()
        .verifyOrderPayment(paymentId, signature, orderId);
    try {
      if (res.status == ApiResponseStatus.completed && res.data!) {
        log('kunukunu completed payment fro the tour');
        Get.toNamed(Routes.SINGLE_TOUR,
            arguments: <dynamic>[checkOutModel.value!.tourID]);
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/local_model/checkout_model.dart';
import '../../../data/models/network_models/order_payment_model.dart';
import '../../../data/repo/local_repo/checkout_repo.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../data/repo/network_repo/razorpay_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/checkout_screen_view.dart';
import 'tour_calculations.dart';

class CheckoutScreenController extends GetxController
    with StateMixin<CheckoutScreenView> {
  Rx<CheckOutModel?> checkOutModel = Rx<CheckOutModel?>(null);
  Rx<OrderPaymentModel> orderPaymentModel = OrderPaymentModel().obs;
  Rx<OrderPaymentModel> orderAdvPaymentModel = OrderPaymentModel().obs;
  GetStorage getStorage = GetStorage();
  String? currentUserCategory;
  late Razorpay razorPay;
  @override
  Future<void> onInit() async {
    super.onInit();
    currentUserCategory =
        await getStorage.read('currentUserCategory') as String;
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
      change(null, status: RxStatus.success());
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: '$e');
    }
  }

  num getTotalAmountofPackageIncludingGST() =>
      CalculateAmount().getAmountofTourPackageIncludingGST(
        adultCount: checkOutModel.value!.adultCount!,
        amount: checkOutModel.value!.amount!,
        childrenCount: checkOutModel.value!.childrenCount!,
        kidsAmount: checkOutModel.value!.kidsAmount!,
        kidsOfferAmount: checkOutModel.value!.kidsOfferAmount!,
        offerAmount: checkOutModel.value!.offerAmount!,
        gst: checkOutModel.value!.gst!,
      );
  num getTotalAmountofPackageExcludingGST() =>
      CalculateAmount().getAmountofTourPackageExcludingGST(
        adultCount: checkOutModel.value!.adultCount!,
        amount: checkOutModel.value!.amount!,
        childrenCount: checkOutModel.value!.childrenCount!,
        kidsAmount: checkOutModel.value!.kidsAmount!,
        kidsOfferAmount: checkOutModel.value!.kidsOfferAmount!,
        offerAmount: checkOutModel.value!.offerAmount!,
        gst: checkOutModel.value!.gst!,
      );

  num getGST() => CalculateAmount().getGSTAmount(
      amountofPackage: getTotalAmountofPackageIncludingGST(),
      gstPercentage: checkOutModel.value!.gst!);

  num getSGST() => CalculateAmount().getSGSTAmount(
        amountofPackage: getTotalAmountofPackageExcludingGST(),
        gstPercentage: checkOutModel.value!.gst!,
      );

  num getCGST() => CalculateAmount().getCGSTAmount(
      amountofPackage: getTotalAmountofPackageExcludingGST(),
      gstPercentage: checkOutModel.value!.gst!);

  int getTotalPassengers() => CalculateAmount().getTotalPassengersCount(
        adultCount: checkOutModel.value!.adultCount!,
        childrenCount: checkOutModel.value!.childrenCount!,
      );

  num getCommissionAmount() => CalculateAmount().getCommisionAmount(
        commission: checkOutModel.value!.commission!,
        totalPassengers: getTotalPassengers(),
      );

  num getGrandTotal() => CalculateAmount().getGrandTotalAmount(
      commission: getCommissionAmount(),
      currentUserCategory: currentUserCategory.toString(),
      packageAmount: getTotalAmountofPackageIncludingGST(),
      gst: getGST());

  void onViewItinerary(String? tourItinerary) {
    Get.toNamed(Routes.PDF_VIEW, arguments: <String>[tourItinerary!]);
  }

  void onClickCancelPurchase() {
    CustomDialog().showCustomDialog(
      'Are You Sure?',
      contentText: 'Do you want to really cancel the purchase?',
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
    final DateTime selectedDate =
        DateTime.parse(checkOutModel.value!.dateOfTravel.toString());
    final DateTime today = DateTime.now();
    if (selectedDate.difference(today).inDays <= 7) {
      CustomDialog().showCustomDialog(
        'Total amount ${getGrandTotal().toStringAsFixed(2)}',
        confirmText: 'Pay Full Amount',
        onCancel: () {
          payAdvanceAmount(id);
        },
        onConfirm: () {
          payFullAmount(id);
        },
      );
    } else {
      CustomDialog().showCustomDialog(
        'Total amount ${getGrandTotal().toStringAsFixed(2)}',
        contentText:
            'Advance amount ${checkOutModel.value!.advanceAmount} + GST(${checkOutModel.value!.gst}%)',
        cancelText: 'Advance Amount',
        confirmText: 'Full Amount',
        onCancel: () {
          payAdvanceAmount(id);
        },
        onConfirm: () {
          payFullAmount(id);
        },
      );
    }
  }

  void onViewPasengers(int? orderiD) {
    Get.toNamed(Routes.TRAVELLERS_SCREEN, arguments: orderiD)!
        .whenComplete(() => loadData());
  }

  Future<void> payAdvanceAmount(int id) async {
    orderAdvPaymentModel.value = await createAdvancePayment(id);
    openRazorPay(orderAdvPaymentModel.value.id.toString());
  }

  Future<void> payFullAmount(int id) async {
    orderPaymentModel.value = await createPayment(id);
    openRazorPay(orderPaymentModel.value.id.toString());
  }

  Future<OrderPaymentModel> createPayment(int iD) async {
    final OrderPaymentModel omp = OrderPaymentModel(
      orderId: iD,
      currency: 'INR',
    );

    try {
      final ApiResponse<OrderPaymentModel> res =
          await PassengerRepository().createPayment(omp);
      if (res.data != null) {
        orderPaymentModel.value = res.data!;
      } else {}
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: '$e');
    }
    return orderPaymentModel.value;
  }

  Future<OrderPaymentModel> createAdvancePayment(int iD) async {
    final OrderPaymentModel omp = OrderPaymentModel(
      orderId: iD,
      currency: 'INR',
    );

    try {
      final ApiResponse<OrderPaymentModel> res =
          await PassengerRepository().createAdvancePayment(omp);
      if (res.data != null) {
        orderAdvPaymentModel.value = res.data!;
      } else {}
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: '$e');
    }
    return orderAdvPaymentModel.value;
  }

  void openRazorPay(String paymentID) {
    final Map<String, Object?> options = <String, Object?>{
      'key': 'rzp_live_VpG0vgAvsBqlnU',
      'name': 'TourMaker',
      'description': 'Pay for your Package Order',
      'order_id': paymentID,
      'external': <String, Object?>{
        'wallets': <String>['paytm'],
      },
    };
    try {
      razorPay.open(options);
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: '$e');
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
    final ApiResponse<bool> res = await RazorPayRepository()
        .verifyOrderPayment(paymentId, signature, orderId);
    try {
      if (res.status == ApiResponseStatus.completed && res.data!) {
        Get.offAllNamed(Routes.HOME)!.then(
          (dynamic value) => Get.snackbar(
            'Success ',
            'Payment Suucess for the tour ${checkOutModel.value!.tourName}',
            backgroundColor: englishViolet,
            colorText: Colors.white,
          ),
        );
      } else {}
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: '$e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomDialog().showCustomDialog('Payment error: ${response.code}',
        contentText: '${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CustomDialog().showCustomDialog('Payment successed: ',
        contentText: 'on : ${response.walletName}');
  }
}

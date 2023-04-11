// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/network_models/payment_model.dart';
import '../../../data/repo/network_repo/payment_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../views/payment_screen_view.dart';

class PaymentScreenController extends GetxController
    with StateMixin<PaymentScreenView>, GetSingleTickerProviderStateMixin {
  late final TabController tabcontroller =
      TabController(length: 3, vsync: this);
  RxList<PaymentModel> processingPayments = <PaymentModel>[].obs;
  RxList<PaymentModel> pendingPayments = <PaymentModel>[].obs;
  RxList<PaymentModel> paidPayments = <PaymentModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapUpcoming() {
    tabcontroller.animateTo(1);
  }

  void onTapCompleted() {
    tabcontroller.animateTo(1);
  }

  void onTapCancelled() {
    tabcontroller.animateTo(1);
  }

  void onTapSingleProcessingPayment() => Get.toNamed(Routes.PAYMENT_SUMMARY);

  void onTapIcon() {}

  void onTapSinglePendingPayment() {
    Get.toNamed(Routes.PAYMENT_SUMMARY);
  }

  void onTapSinglePaidView() {}

  Future<void> loadData() async {
    await loadProcessingPayments();
    await loadPendingPayments();
    await loadPaidPayments();
    change(null, status: RxStatus.success());
  }

  Future<void> loadProcessingPayments() async {
    final ApiResponse<List<PaymentModel>> res =
        await PaymentRepository().getAllPayments('processing');
    log('adeeb processing  ${res.message}');
    if (res.data != null) {
      processingPayments.value = res.data!;
    }
  }

  Future<void> loadPendingPayments() async {
    final ApiResponse<List<PaymentModel>> res =
        await PaymentRepository().getAllPayments('pending');
    log('adeeb pending  ${res.message}');

    if (res.data != null) {
      pendingPayments.value = res.data!;
    } else {}
  }

  Future<void> loadPaidPayments() async {
    final ApiResponse<List<PaymentModel>> res =
        await PaymentRepository().getAllPayments('paid');
    log('adeeb paid  ${res.message}');

    if (res.data != null) {
      paidPayments.value = res.data!;
    } else {}
  }
}

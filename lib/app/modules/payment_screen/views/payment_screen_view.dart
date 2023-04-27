import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/payment.dart';
import '../controllers/payment_screen_controller.dart';

class PaymentScreenView extends GetView<PaymentScreenController> {
  const PaymentScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final PaymentScreenController controller =
        Get.put(PaymentScreenController());
    return Scaffold(
        extendBody: true,
        appBar: const CustomAppBar(title: Text('Payments')),
        body: controller.obx(
          onLoading: const CustomLoadingScreen(),
          (dynamic state) => Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 17),
                child: Container(
                  height: 60,
                  width: 100.w,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFF1F1F1),
                  ),
                  child: TabBar(
                    controller: controller.tabcontroller,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicator: BoxDecoration(
                      color: englishViolet,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    tabs: const <Widget>[
                      Tab(
                        child: Text(
                          'Processing',
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Pending',
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Paid',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TabBarView(
                    controller: controller.tabcontroller,
                    children: <Widget>[
                      buildProcessingView(),
                      buildPendingView(),
                      buildPaidView(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildProcessingView() {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: controller.loadData,
        child: controller.processingPayments.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.processingPayments.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () => controller.onTapSingleProcessingPayment(
                      controller.processingPayments[index].id!),
                  child: PaymentTile(
                    tourName: controller.processingPayments[index].tourName
                        .toString(),
                    tourAmount: controller.processingPayments[index].amountPaid
                        .toString(),
                    tourCode: controller.processingPayments[index].orderDate
                        .toString()
                        .parseFromIsoDate()
                        .toDateTime(),
                  ),
                ),
              )
            : const CustomErrorScreen(
                errorText: 'No processing \n payments here'),
      );
    });
  }

  Widget buildPendingView() {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: controller.loadData,
        child: controller.pendingPayments.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.pendingPayments.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () => controller.onTapSinglePendingPayment(
                      controller.pendingPayments[index].id!),
                  child: PaymentTile(
                    tourName:
                        controller.pendingPayments[index].tourName.toString(),
                    tourAmount:
                        controller.pendingPayments[index].amountPaid.toString(),
                    tourCode: controller.pendingPayments[index].orderDate
                        .toString()
                        .parseFromIsoDate()
                        .toDateTime(),
                  ),
                ),
              )
            : const CustomErrorScreen(errorText: 'No pending \n payments here'),
      );
    });
  }

  Widget buildPaidView() {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: controller.loadData,
        child: controller.paidPayments.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.paidPayments.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () => controller
                      .onTapSinglePaidView(controller.paidPayments[index].id!),
                  child: PaymentTile(
                    tourName:
                        controller.paidPayments[index].tourName.toString(),
                    tourAmount:
                        controller.paidPayments[index].amountPaid.toString(),
                    tourCode: controller.paidPayments[index].orderDate
                        .toString()
                        .parseFromIsoDate()
                        .toDateTime(),
                  ),
                ),
              )
            : const CustomErrorScreen(errorText: 'No paid \n payments here'),
      );
    });
  }
}

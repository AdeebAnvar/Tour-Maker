import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../controllers/payment_summary_controller.dart';

class PaymentSummaryView extends GetView<PaymentSummaryController> {
  const PaymentSummaryView({super.key});
  @override
  Widget build(BuildContext context) {
    final PaymentSummaryController controller =
        Get.put(PaymentSummaryController());
    return Scaffold(
        appBar: const CustomAppBar(title: Text('Booking Summary')),
        body: controller.obx(
          onEmpty: const CustomErrorScreen(errorText: 'Nothing found....'),
          onLoading: const CustomLoadingScreen(),
          (PaymentSummaryView? state) => Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color(0xFFF1F1F1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    height: 193,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Kashmir Tour', style: subheading3),
                                  Text(
                                      controller.bookingList[0].tourCode
                                          .toString(),
                                      style: paragraph4),
                                ],
                              ),
                              // Column(
                              //   children: <Widget>[
                              //     Text('Booked Date', style: subheading3),
                              //     // Text(
                              //     //     controller.bookingList[0].
                              //     //         .toString(),
                              //     //     style: paragraph4),
                              //   ],
                              // ),
                              Column(
                                children: <Widget>[
                                  Text('Tour Date', style: subheading3),
                                  Text(
                                      controller.bookingList[0].dateOfTravel
                                          .toString()
                                          .parseFromIsoDate()
                                          .toDate(),
                                      style: paragraph4),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => controller
                              .onClickPassengers(controller.bookingList[0].id),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 73,
                                height: 65,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    topRight: Radius.circular(40),
                                  ),
                                  color: englishViolet,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        TourMaker.people,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        controller
                                            .getTotalTravellersCount()
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80.w,
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: englishViolet,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Type',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          )),
                      const VerticalDivider(color: Colors.white),
                      Text(
                        'Amount',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      width: 100.w,
                      padding: const EdgeInsets.symmetric(
                          vertical: 22, horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Package Amount     :', style: subheading3),
                              Text('₹ ${controller.bookingList[0].totalAmount}',
                                  style: subheading2),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text('Commission      :'),
                              Text('500'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Total Amount      :', style: subheading3),
                              Text(
                                  controller.bookingList[0].totalAmount
                                      .toString(),
                                  style: subheading2),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('GST(${controller.bookingList[0].gst}):',
                                  style: subheading3),
                              Text('₹ ${controller.bookingList[0].gstAmount}',
                                  style: subheading2),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text('Grand Total     :'),
                              Text('500'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Payable Amount         :'),
                              Text(controller.bookingList[0].payableAmount
                                  .toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Paid Amount     :'),
                              Text(controller.bookingList[0].payableAmount
                                  .toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Remaining Amount     :'),
                              Text(controller.getRemainingAmount().toString()),
                            ],
                          ),
                          if (controller.getRemainingAmount() != 0)
                            Obx(() {
                              return CustomButton().showButtonWithGradient(
                                isLoading: controller.isLoading.value,
                                text: 'Pay Remaining Amount',
                                onPressed: () =>
                                    controller.onClickPayRemainingAmount(
                                        controller.bookingList[0].id!),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

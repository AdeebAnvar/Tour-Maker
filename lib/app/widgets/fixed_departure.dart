import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/style.dart';
import '../../core/tour_maker_icons.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/string_utils.dart';
import '../modules/single_tour/controllers/single_tour_controller.dart';
import 'custom_elevated_button.dart';

class FixedDepartures extends StatelessWidget {
  const FixedDepartures(
      {super.key,
      required this.controller,
      required this.countOfAdults,
      required this.countOfChildrens});
  final SingleTourController controller;
  final Widget countOfAdults;
  final Widget countOfChildrens;
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMoreFixedTours();
      }
    });
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 90,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: controller.batchTourPackageDatesRX.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () {
                    controller.selectedBatchTourIndex.value = index;
                  },
                  child: Obx(() {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      width: 52,
                      height: 90,
                      decoration: BoxDecoration(
                        color: index == controller.selectedBatchTourIndex.value
                            ? englishViolet
                            : backgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          controller.batchTourPackageDatesRX[index].dateOfTravel
                              .toString()
                              .parseFromIsoDate()
                              .toDatewithMonthFormat(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color:
                                index == controller.selectedBatchTourIndex.value
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '  Adults',
                  style: subheading2,
                ),
                countOfAdults
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '  Childrens',
                  style: subheading2,
                ),
                countOfChildrens
              ],
            ),
            const SizedBox(height: 10),
            Text(
                'Transportation via ${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].transportationMode}',
                style: subheading1),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: backgroundColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Available seats : ${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].availableSeats}/${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].totalSeats}',
                      style: subheading1,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: controller.adult.value.toString(),
                        style: const TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          const TextSpan(
                            text: ' Adults x  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          if (controller
                                  .batchTourPackageDatesRX[
                                      controller.selectedBatchTourIndex.value]
                                  .offerAmount ==
                              0)
                            TextSpan(
                              text: controller
                                  .batchTourPackageDatesRX[
                                      controller.selectedBatchTourIndex.value]
                                  .amount
                                  .toString(),
                            )
                          else
                            TextSpan(text: '', children: <TextSpan>[
                              TextSpan(
                                text:
                                    '₹ ${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].amount}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '    ₹ ${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].offerAmount}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    //////batch tour
                    RichText(
                      text: TextSpan(
                        text: controller.children.value.toString(),
                        style: const TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          const TextSpan(
                            text: ' Childrens x  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          if (controller
                                  .batchTourPackageDatesRX[
                                      controller.selectedBatchTourIndex.value]
                                  .kidsOfferAmount ==
                              0)
                            TextSpan(
                              text: controller
                                  .batchTourPackageDatesRX[
                                      controller.selectedBatchTourIndex.value]
                                  .amount
                                  .toString(),
                            )
                          else
                            TextSpan(text: '', children: <TextSpan>[
                              TextSpan(
                                text:
                                    '₹ ${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].kidsAmount}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '    ₹ ${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].kidsOfferAmount}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700))
                            ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Total Amount', style: heading3),
                            Text(
                                '(Excluding GST ${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].gstPercent}%)',
                                style: paragraph3),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: <Widget>[
                            Text(
                              '₹ ${controller.getTotalAmountOFtour(controller.adult.value, controller.children.value, controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value], controller.selectedBatchTourIndex.value)}',
                              style: heading2,
                            ),
                            Text(
                              'Pay now : ₹ ${controller.batchTourPackageDatesRX[controller.selectedBatchTourIndex.value].advanceAmount! * (controller.adult.value + controller.children.value)}',
                              style: paragraph4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => CustomButton().showIconButtonWithGradient(
                isLoading: controller.isloading.value,
                height: 80,
                width: 100.w,
                text: controller.userType == 'demo'
                    ? '      Add details'
                    : '   Enter Passenger Details',
                onPressed: () => controller.onClickAddBatchTourPassenger(
                    controller.batchTour.value
                        .packageData![controller.selectedBatchTourIndex.value]),
              ),
            ),
            if (controller.userType == 'demo')
              const SizedBox()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'For Direct Booking',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (controller.currentUserCategory != 'standard')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: controller.onCallClicked,
                          icon: Icon(TourMaker.call,
                              color: Colors.grey.shade800, size: 20),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: controller.onWhatsAppClicked,
                          child: SvgPicture.asset(
                            'assets/whatsapp.svg',
                            height: 20,
                            width: 20,
                          ),
                        )
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: controller.onWhatsAppClicked,
                      child: SvgPicture.asset(
                        'assets/whatsapp.svg',
                        height: 20,
                        width: 20,
                      ),
                    )
                ],
              ),
          ],
        ),
      );
    });
  }
}

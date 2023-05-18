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
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.batchTours.value.packageData?.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () {
                    controller.selectedBatchIndex.value = index;
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
                        color: index == controller.selectedBatchIndex.value
                            ? englishViolet
                            : backgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          controller
                              .batchTours.value.packageData![index].dateOfTravel
                              .toString()
                              .parseFromIsoDate()
                              .toDatewithMonthFormat(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: index == controller.selectedBatchIndex.value
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
                'Transportation via ${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].transportationMode}',
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
                      'Available seats : ${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].availableSeats}/${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].totalSeats}',
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
                                  .batchTours
                                  .value
                                  .packageData![
                                      controller.selectedBatchIndex.value]
                                  .offerAmount ==
                              0)
                            TextSpan(
                              text: controller
                                  .batchTours
                                  .value
                                  .packageData![
                                      controller.selectedBatchIndex.value]
                                  .amount
                                  .toString(),
                            )
                          else
                            TextSpan(text: '', children: <TextSpan>[
                              TextSpan(
                                text:
                                    '₹ ${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].amount}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '    ₹ ${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].offerAmount}',
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
                                  .batchTours
                                  .value
                                  .packageData![
                                      controller.selectedBatchIndex.value]
                                  .kidsOfferAmount ==
                              0)
                            TextSpan(
                              text: controller
                                  .batchTours
                                  .value
                                  .packageData![
                                      controller.selectedBatchIndex.value]
                                  .amount
                                  .toString(),
                            )
                          else
                            TextSpan(text: '', children: <TextSpan>[
                              TextSpan(
                                text:
                                    '₹ ${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].kidsAmount}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '    ₹ ${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].kidsOfferAmount}',
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
                                '(Excluding GST ${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].gstPercent}%)',
                                style: paragraph3),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: <Widget>[
                            Text(
                              '₹ ${controller.getTotalAmountOFtour(controller.adult.value, controller.children.value, controller.batchTours.value.packageData![controller.selectedBatchIndex.value], controller.selectedBatchIndex.value)}',
                              style: heading2,
                            ),
                            Text(
                              'Pay now : ₹ ${controller.batchTours.value.packageData![controller.selectedBatchIndex.value].advanceAmount}',
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
                isLoading: controller.isLoading.value,
                height: 80,
                width: 100.w,
                text: '   Enter Passenger Details',
                onPressed: () => controller.onClickAddPassenger(controller
                    .batchTours
                    .value
                    .packageData![controller.selectedBatchIndex.value]),
              ),
            ),
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

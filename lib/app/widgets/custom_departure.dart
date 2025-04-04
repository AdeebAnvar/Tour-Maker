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

class CustomDeparture extends StatelessWidget {
  const CustomDeparture(
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
                itemCount: controller.individualTourPackagesRX.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () {
                    controller.selectedIndividualTourDateIndex.value = index;
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
                        color: index ==
                                controller.selectedIndividualTourDateIndex.value
                            ? englishViolet
                            : backgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          controller
                              .individualTourPackagesRX[index].dateOfTravel
                              .toString()
                              .parseFromIsoDate()
                              .toDatewithMonthFormat(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: index ==
                                    controller
                                        .selectedIndividualTourDateIndex.value
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
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
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
                                  .individualTourPackagesRX[controller
                                      .selectedIndividualTourDateIndex.value]
                                  .offerAmount ==
                              0)
                            TextSpan(
                              text: controller
                                  .individualTourPackagesRX[controller
                                      .selectedIndividualTourDateIndex.value]
                                  .amount
                                  .toString(),
                            )
                          else
                            TextSpan(text: '', children: <TextSpan>[
                              TextSpan(
                                text:
                                    '₹ ${controller.individualTourPackagesRX[controller.selectedIndividualTourDateIndex.value].amount}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '    ₹ ${controller.individualTourPackagesRX[controller.selectedIndividualTourDateIndex.value].offerAmount}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700))
                            ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    //////
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
                                  .individualTourPackagesRX[controller
                                      .selectedIndividualTourDateIndex.value]
                                  .kidsOfferAmount ==
                              0)
                            TextSpan(
                              text: controller
                                  .individualTourPackagesRX[controller
                                      .selectedIndividualTourDateIndex.value]
                                  .amount
                                  .toString(),
                            )
                          else
                            TextSpan(text: '', children: <TextSpan>[
                              TextSpan(
                                text:
                                    '₹ ${controller.individualTourPackagesRX[controller.selectedIndividualTourDateIndex.value].kidsAmount}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '    ₹ ${controller.individualTourPackagesRX[controller.selectedIndividualTourDateIndex.value].kidsOfferAmount}',
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
                                '(Excluding GST ${controller.individualTourPackagesRX[controller.selectedIndividualTourDateIndex.value].gstPercent}%)',
                                style: paragraph2),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: <Widget>[
                            Text(
                                '₹ ${controller.getTotalAmountOFtour(controller.adult.value, controller.children.value, controller.individualTourPackagesRX[controller.selectedIndividualTourDateIndex.value], controller.selectedIndividualTourDateIndex.value)}',
                                style: heading2),
                            const SizedBox(height: 5),
                            Text(
                              'Pay now : ₹ ${controller.individualTourPackagesRX[controller.selectedIndividualTourDateIndex.value].advanceAmount}',
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
                onPressed: () => controller.onClickAddindividualTourPassenger(
                    controller.individualTourPackagesRX[
                        controller.selectedIndividualTourDateIndex.value]),
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
                  const SizedBox(width: 40),
                  if (controller.currentUserCategory != 'standard')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: controller.onCallClicked,
                          icon: Icon(TourMaker.call,
                              color: Colors.grey.shade800, size: 20),
                        ),
                        const SizedBox(width: 50),
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

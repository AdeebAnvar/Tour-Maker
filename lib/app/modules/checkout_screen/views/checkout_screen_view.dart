import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/checkout_screen_controller.dart';

class CheckoutScreenView extends GetView<CheckoutScreenController> {
  const CheckoutScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final CheckoutScreenController controller =
        Get.put(CheckoutScreenController());
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Checkout Screen'),
      ),
      body: controller.obx(
        (CheckoutScreenView? state) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.bounceInOut,
          margin: const EdgeInsets.all(10),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(controller.checkOutModel.value!.tourName.toString(),
                        style: heading2),
                    Text(controller.checkOutModel.value!.tourCode.toString(),
                        style: subheading2),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ActionChip(
                          backgroundColor: englishViolet,
                          label: const Text('View Itinerary'),
                          labelStyle: const TextStyle(color: Colors.white),
                          onPressed: () => controller.onViewItinerary(
                              controller.checkOutModel.value!.tourItinerary),
                        ),
                        ActionChip(
                          backgroundColor: englishViolet,
                          label: const Text('View Passengers'),
                          labelStyle: const TextStyle(color: Colors.white),
                          onPressed: () => controller.onViewPasengers(
                              controller.checkOutModel.value!.orderID),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    buildItem(
                        'Date of Travel :',
                        controller.checkOutModel.value!.dateOfTravel
                            .toString()
                            .parseFromIsoDate()
                            .toDocumentDateFormat()),
                    buildItem('No. of Adults :',
                        '${controller.checkOutModel.value!.adultCount} pax'),
                    if (controller.checkOutModel.value!.childrenCount == 0)
                      const SizedBox()
                    else
                      buildItem('No. of Children :',
                          '${controller.checkOutModel.value!.childrenCount} pax'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Adult Amount :', style: subheading1),
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: const TextStyle(color: Colors.grey),
                            children: <TextSpan>[
                              const TextSpan(
                                text: '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              if (controller.checkOutModel.value?.offerAmount ==
                                  null)
                                TextSpan(
                                    text:
                                        '₹ ${controller.checkOutModel.value!.amount}/pax',
                                    style: TextStyle(
                                      color: fontColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              else
                                TextSpan(text: '', children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '₹ ${controller.checkOutModel.value!.amount}',
                                    style: TextStyle(
                                      color: fontColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '  ₹ ${controller.checkOutModel.value!.offerAmount}/pax',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: fontColor),
                                  )
                                ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (controller.checkOutModel.value!.childrenCount == 0)
                      const SizedBox()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Children Amount :', style: subheading1),
                          RichText(
                            text: TextSpan(
                              text: '',
                              style: const TextStyle(color: Colors.grey),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (controller
                                        .checkOutModel.value?.kidsOfferAmount ==
                                    null)
                                  TextSpan(
                                      text:
                                          '₹ ${controller.checkOutModel.value!.kidsAmount}/pax',
                                      style: TextStyle(
                                        color: fontColor,
                                        fontWeight: FontWeight.w700,
                                      ))
                                else
                                  TextSpan(text: '', children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '₹ ${controller.checkOutModel.value!.kidsAmount}',
                                      style: TextStyle(
                                        color: fontColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '  ₹ ${controller.checkOutModel.value!.kidsOfferAmount}/pax',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: fontColor),
                                    )
                                  ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    buildItem(
                        'Total Amount :', '₹ ${controller.getTotalAmount()}'),
                    if (currentUserCategory == 'standard')
                      const SizedBox()
                    else
                      buildItem('Discount :',
                          '- ₹ ${controller.getCommissionAmount()}'),
                    const Divider(
                      color: Colors.grey,
                      endIndent: 40,
                      indent: 50,
                    ),
                    buildItem('Total Amount : ',
                        '₹ ${controller.getTotalAmounttoBePaid().toStringAsFixed(2)}'),
                    buildItem(
                        'CGST (${controller.checkOutModel.value!.gst! / 2}%):',
                        '₹ ${controller.getCGST()}'),
                    buildItem(
                        'SGST (${controller.checkOutModel.value!.gst! / 2}%):',
                        '₹ ${controller.getSGST()}'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Grand Total :',
                          style: heading3.copyWith(fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 20,
                          width: 160,
                          child: Text(
                            '₹ ${controller.getGrandTotal().toStringAsFixed(2)}',
                            style: heading3.copyWith(
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.visible),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 160,
                          child: Text(
                            '(Includes GST ${controller.checkOutModel.value!.gst}%)',
                            style: subheading1.copyWith(
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.visible),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 30.w,
                          margin: const EdgeInsets.all(10),
                          height: 06.h,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: fontColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => controller.onClickCancelPurchase(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        Container(
                          width: 40.w,
                          height: 06.h,
                          margin: const EdgeInsets.all(10),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: englishViolet,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => controller.onClickconfirmPurchase(
                                controller.checkOutModel.value!.orderID!),
                            child: const Text('Purchase'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildItem(String label, String item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: subheading1),
        Text(item, style: subheading1)
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_departure.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/custom_tab.dart';
import '../../../widgets/custom_tooltip.dart';
import '../../../widgets/customdatepicker.dart';
import '../../../widgets/fixed_departure.dart';
import '../controllers/single_tour_controller.dart';

class SingleTourView extends GetView<SingleTourController> {
  const SingleTourView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final SingleTourController controller = Get.put(SingleTourController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAPPBAR(controller),
      body: controller.obx(
        onLoading: const CustomLoadingScreen(),
        (SingleTourView? state) => Stack(
          children: <Widget>[
            tourImge(controller),
            tourName(controller),
            tourDetailContainer(screenWidth, controller, context),
          ],
        ),
      ),
    );
  }

  CustomAppBar buildAPPBAR(SingleTourController controller) {
    return CustomAppBar(
      actions: <Widget>[
        Obx(() {
          return GestureDetector(
            onTap: () => controller.onClickAddToFavourites(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: controller.isFavourite.value
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(Icons.favorite_outline),
              ),
            ),
          );
        }),
        const SizedBox(
          width: 20,
          height: 20,
        )
      ],
    );
  }

  SingleChildScrollView tourDetailContainer(double screenWidth,
      SingleTourController controller, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: screenWidth - 70),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 35),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: Text(
                          '${controller.batchTours.value.tourData?.tourCode}',
                          style: heading2,
                        ),
                      ),
                      CustomToolTip(
                          onPressed: () => controller.onViewItineraryClicked(
                              controller.batchTours.value.tourData!.itinerary!),
                          label: 'VIEW ITINERARY',
                          icon: TourMaker.group_2)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text('Tour Description', style: heading3)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        '${controller.batchTours.value.tourData?.description}',
                        style: paragraph1),
                  ),
                  const SizedBox(height: 10),
                  CustomTabBar(controller: controller),
                  const SizedBox(height: 30),
                  Obx(
                    () => controller.selectedIndex.value == 0
                        ? buildFixedDeparture()
                        : Column(
                            children: [
                              CustomDatePickerField(
                                labelName: 'Select Tour Date',
                                validator: (String? value) {
                                  return null;
                                },
                                onChange: (String value) =>
                                    controller.onSerchTextChanged(value),
                              ),
                              buildCustomDeparture(),
                            ],
                          ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned tourName(SingleTourController controller) {
    return Positioned(
      left: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Text(
          '${controller.batchTours.value.tourData?.name!.split(' ').join('\n')}',
          style: const TextStyle(
            fontFamily: 'Tahu',
            color: Colors.white,
            fontSize: 56,
          ),
        ),
      ),
    );
  }

  Container tourImge(SingleTourController controller) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            '${controller.batchTours.value.tourData!.image}',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildCustomDeparture() {
    if (controller.singleTours.isNotEmpty) {
      return CustomDeparture(
          controller: controller,
          countOfAdults: countOfAdults(),
          countOfChildrens: countOfChildrens());
    } else {
      return Column(
        children: <Widget>[
          const SizedBox(height: 30),
          Image.asset('assets/empty screen.png'),
          const SizedBox(height: 10),
          const Text(
            'No Custom Departures \nfor this tour',
            textAlign: TextAlign.center,
          )
        ],
      );
    }
  }

  Widget buildFixedDeparture() {
    if (controller.batchTours.value.packageData != null) {
      return FixedDepartures(
          controller: controller,
          countOfAdults: countOfAdults(),
          countOfChildrens: countOfChildrens());
    } else {
      return Column(
        children: <Widget>[
          const SizedBox(height: 30),
          Image.asset('assets/empty screen.png'),
          const SizedBox(height: 10),
          const Text(
            'No Fixed Departures \nfor this tour',
            textAlign: TextAlign.center,
          )
        ],
      );
    }
  }

  Widget countOfChildrens() {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: 100,
        height: 37,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () => controller.onClickSubtractChildren(),
              child: Container(
                width: 25,
                height: 25,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: englishViolet),
                child: const Center(
                  child: Text(
                    '--',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Text(controller.children.value.toString()),
            GestureDetector(
              onTap: () => controller.onClickAddChildren(),
              child: Container(
                width: 25,
                height: 25,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: englishViolet),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget countOfAdults() {
    return Obx(
      () {
        return SizedBox(
          width: 100,
          height: 37,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () => controller.onClickAdultSubtract(),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: englishViolet),
                  child: const Center(
                    child: Text(
                      '--',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Text(controller.adult.value.toString()),
              GestureDetector(
                onTap: () => controller.onClickAdultAdd(),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: englishViolet),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

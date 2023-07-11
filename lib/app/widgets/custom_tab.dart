import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/style.dart';
import '../modules/single_tour/controllers/single_tour_controller.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.controller,
  });
  final SingleTourController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              controller.selectedTabIndex.value = 0;
            },
            child: Obx(() {
              return AnimatedContainer(
                margin: const EdgeInsets.all(10),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                width: 37.w,
                decoration: BoxDecoration(
                  color: controller.selectedTabIndex.value == 0
                      ? englishViolet
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Fixed Departure',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: controller.selectedTabIndex.value == 0
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
          GestureDetector(
            onTap: () {
              controller.selectedTabIndex.value = 1;
            },
            child: Obx(() {
              return AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 600),
                width: 37.w,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: controller.selectedTabIndex.value == 1
                      ? englishViolet
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Custom Departure',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: controller.selectedTabIndex.value == 1
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

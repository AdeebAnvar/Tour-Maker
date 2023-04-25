import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/theme/style.dart';

import '../../../data/models/local_model/budget_models.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../controllers/filter_screen_controller.dart';

class FilterScreenView extends GetView<FilterScreenController> {
  const FilterScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final FilterScreenController controller = Get.put(FilterScreenController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: fontColor),
        foregroundColor: fontColor,
        title: const Text('Filters'),
      ),
      body: controller.obx(
        onLoading: const CustomLoadingScreen(),
        (FilterScreenView? state) => Column(
          children: <Widget>[
            Obx(
              () {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.70,
                        child: buildFilterButtonSection(controller),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: buildFilterScreenSection(context, controller),
                    )
                  ],
                );
              },
            ),
            Expanded(
              child: buildSearchButton(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  Container buildSearchButton(
      BuildContext context, FilterScreenController controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.70,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        // color: englishViolet,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Center(
        child: Obx(
          () {
            return CustomButton().showIconButtonWithGradient(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.10,
                isLoading: controller.isLoading.value,
                text: '   Show Results',
                onPressed: () {
                  controller.selectedIndex.value == 0
                      ? controller.filterbyDestinations()
                      : controller.selectedIndex.value == 1
                          ? controller.filterbyBudget()
                          : controller.selectedIndex.value == 2
                              ? controller.filterbyCategory()
                              : controller.filterbyDuration();
                },
                bgColor: englishViolet);
          },
        ),
      ),
    );
  }

  SizedBox buildFilterScreenSection(
      BuildContext context, FilterScreenController controller) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: Scaffold(
          body: controller.selectedIndex.value == 0
              ? buildDestinationView(controller)
              : controller.selectedIndex.value == 1
                  ? buildBudgetView(controller)
                  : controller.selectedIndex.value == 2
                      ? buildCategoryView(controller)
                      : buildDurationView(controller)),
    );
  }

  Column buildFilterButtonSection(FilterScreenController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: controller.selectedIndex.value == 0
                  ? Colors.white
                  : englishViolet,
              backgroundColor: controller.selectedIndex.value == 0
                  ? englishViolet
                  : Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  topLeft: Radius.circular(18),
                ),
              ),
            ),
            onPressed: () {
              controller.selectedIndex.value = 0;
            },
            child: const Text(
              '   Destinations',
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: controller.selectedIndex.value == 1
                  ? Colors.white
                  : englishViolet,
              backgroundColor: controller.selectedIndex.value == 1
                  ? englishViolet
                  : Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                topLeft: Radius.circular(18),
              )),
            ),
            onPressed: () {
              controller.selectedIndex.value = 1;
            },
            child: const Text('   Budget'),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: controller.selectedIndex.value == 2
                  ? Colors.white
                  : englishViolet,
              backgroundColor: controller.selectedIndex.value == 2
                  ? englishViolet
                  : Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                topLeft: Radius.circular(18),
              )),
            ),
            onPressed: () {
              controller.selectedIndex.value = 2;
            },
            child: const Text(
              '   Category',
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: controller.selectedIndex.value == 3
                  ? Colors.white
                  : englishViolet,
              backgroundColor: controller.selectedIndex.value == 3
                  ? englishViolet
                  : Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                topLeft: Radius.circular(18),
              )),
            ),
            onPressed: () {
              controller.selectedIndex.value = 3;
            },
            child: const Text('   Duration'),
          ),
        ),
      ],
    );
  }

  Padding buildCategoryView(FilterScreenController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView.builder(
        itemCount: controller.categoryList.length,
        itemBuilder: (BuildContext context, int index) =>
            buildcategoriesList(controller, index),
      ),
    );
  }

  Padding buildBudgetView(FilterScreenController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView.builder(
        itemCount: budgetList.length,
        itemBuilder: (BuildContext context, int index) =>
            buildBudgetList(controller, index),
      ),
    );
  }

  Padding buildDestinationView(FilterScreenController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.destinationList.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildDestinationsList(controller, index),
            ),
          ),
          CheckboxListTile(
              value: controller.showDomesticTours.value,
              onChanged: (bool? value) {
                controller.showDomesticTours.value = value ?? false;
                if (value ?? false) {
                  // Clear the selected destinations when "Show Domestic Tours" is selected
                  controller.selectedDestinations.clear();
                  for (int i = 0;
                      i < controller.isSelectedDestinations.length;
                      i++) {
                    controller.isSelectedDestinations[i] = false;
                  }
                }
              },
              activeColor: englishViolet,
              checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                'Show Domestic Tours',
                style: subheading2,
              )),
        ],
      ),
    );
  }

  Widget buildDestinationsList(FilterScreenController controller, int index) {
    return Obx(() {
      return CheckboxListTile(
          value: controller.isSelectedDestinations[index],
          onChanged: (bool? value) =>
              controller.onDestinationCheck(value, index),
          activeColor: englishViolet,
          checkboxShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            controller.destinationList[index].destination.toString(),
            style: subheading2,
          ));
    });
  }

  // Widget buildBudgetList(FilterScreenController controller, int index) {
  //   final Budget budget = budgetList[index];
  //   return Obx(() {
  //     return RadioListTile<Budget>(
  //       value: budget,
  //       groupValue: controller.selectedBudget.value,
  //       onChanged: (Budget? value) => controller.onBudgetCheck(index),
  //       activeColor: englishViolet,
  //       title: Column(
  //         children: <Widget>[
  //           Text(
  //             budget.title,
  //             style: subheading2,
  //           ),
  //           Text(
  //             budget.value,
  //             style: subheading2,
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }
  Widget buildBudgetList(FilterScreenController controller, int index) {
    return Obx(() {
      final Budget budget = budgetList[index];
      return Column(
        children: <Widget>[
          CheckboxListTile(
            value: controller.selectedBudget.value == budget,
            onChanged: (bool? value) => controller.onBudgetCheck(value, budget),
            activeColor: englishViolet,
            checkboxShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(budget.title, style: subheading2),
          ),
        ],
      );
    });
  }

  Widget buildcategoriesList(FilterScreenController controller, int index) {
    return Obx(() {
      return CheckboxListTile(
          value: controller.isSelectedCategories[index],
          onChanged: (bool? value) => controller.onCategoryCheck(value, index),
          activeColor: englishViolet,
          checkboxShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            controller.categoryList[index].name.toString(),
            style: subheading2,
          ));
    });
  }

  Widget buildDurationView(FilterScreenController controller) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Text('Enter the Duration'),
            SizedBox(
              width: 60,
              height: 40,
              child: Center(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    cursorColor: englishViolet,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onChanged: (String value) =>
                        controller.duration.value = value,
                  ),
                ),
              ),
            ),
            const Text('Days'),
          ],
        ),
      ),
    );
  }
}

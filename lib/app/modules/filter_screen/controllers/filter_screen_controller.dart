import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/style.dart';

import '../../../data/models/local_model/budget_models.dart';
import '../../../data/models/network_models/category_model.dart';
import '../../../data/models/network_models/destinations_model.dart';
import '../../../data/models/network_models/package_model.dart';
import '../../../data/repo/network_repo/category_repo.dart';
import '../../../data/repo/network_repo/destination_repo.dart';
import '../../../data/repo/network_repo/filter_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../views/filter_screen_view.dart';

class FilterScreenController extends GetxController
    with StateMixin<FilterScreenView> {
  RxList<DestinationsModel> destinationList = <DestinationsModel>[].obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<bool> isSelectedDestinations = <bool>[].obs;
  RxList<bool> isSelectedCategories = <bool>[].obs;
  RxBool isLoading = false.obs;
  RxBool showDomesticTours = false.obs;
  Rx<Budget> selectedBudget = Budget(title: '', value: '').obs;
  RxInt selectedIndex = 0.obs;
  dynamic selectedDestinationsList;
  dynamic selectedCategoryList;
  List<DestinationsModel> selectedDestinations = <DestinationsModel>[];
  List<CategoryModel> selectedCategories = <CategoryModel>[];
  Rx<String> duration = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());

    await listAllDestinations();
    await listAllCategories();
  }

  Future<void> listAllCategories() async {
    final ApiResponse<List<CategoryModel>> res =
        await CategoryRepository().getAllCategory();
    try {
      if (res != null) {
        categoryList.value = res.data!;
        isSelectedCategories
            .assignAll(List<bool>.filled(res.data!.length, false));

        change(null, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.error());
      }
    } catch (e) {
      log('catch error $e');
    }
  }

  Future<void> listAllDestinations() async {
    final ApiResponse<List<DestinationsModel>> res =
        await DestinationRepository().getAllDestinations();
    try {
      if (res != null) {
        destinationList.value = res.data!;
        isSelectedDestinations
            .assignAll(List<bool>.filled(res.data!.length, false));
        change(null, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.error());
      }
    } catch (e) {
      log('catch error $e');
    }
  }

  Future<void> filterbyDestinations() async {
    log('destinations');
    isLoading.value = true;

    if (selectedDestinationsList != null) {
      log('selected destination');
      final ApiResponse<List<PackageModel>> res =
          await FilterRepository().getDestination(selectedDestinationsList);
      log('adeeb ${res.status}');
      log('adeeb ${res.message}');
      log('adeeb ${res.data}');
      if (res.status == ApiResponseStatus.completed) {
        Get.toNamed(Routes.TOURS_VIEW, arguments: res.data)!
            .whenComplete(() => loadData());
        selectedDestinations.clear();
        change(null, status: RxStatus.success());
      } else {
        Get.to(
          const Scaffold(
            appBar: CustomAppBar(),
            body: Center(
              child: CustomErrorScreen(
                errorText: 'sorry Nothing \n Found here',
              ),
            ),
          ),
        )!
            .whenComplete(() => loadData());
        change(null, status: RxStatus.empty());
      }
    } else if (showDomesticTours.value == true) {
      change(null, status: RxStatus.loading());

      log('show domestic');
      final ApiResponse<List<PackageModel>> res =
          await FilterRepository().getDomesticTours();
      if (res.status == ApiResponseStatus.completed) {
        log('dafa');
        final List<PackageModel> domesticTours = res.data!;
        Get.toNamed(Routes.TOURS_VIEW, arguments: domesticTours)!
            .whenComplete(() => loadData());
        change(null, status: RxStatus.success());
      } else {
        Get.to(
          const Scaffold(
            appBar: CustomAppBar(),
            body: Center(
              child: CustomErrorScreen(
                errorText: 'sorry Nothing \n Found here',
              ),
            ),
          ),
        )!
            .whenComplete(() => loadData());
        change(null, status: RxStatus.empty());
      }
    } else {
      log('empty');
      Get.snackbar(
        'Please Select a destination',
        'select atleast one destination',
        backgroundColor: englishViolet,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  Future<void> filterbyBudget() async {
    log('budget');
    change(null, status: RxStatus.loading());

    final ApiResponse<List<PackageModel>> res =
        await FilterRepository().getToursbyBudget(selectedBudget.value.value);
    if (res.status == ApiResponseStatus.completed) {
      Get.toNamed(Routes.TOURS_VIEW, arguments: res.data)!
          .whenComplete(() => loadData());
      change(null, status: RxStatus.success());
    } else {
      Get.to(
        const Scaffold(
          appBar: CustomAppBar(),
          body: Center(
            child: CustomErrorScreen(
              errorText: 'sorry Nothing \n Found here',
            ),
          ),
        ),
      )!
          .whenComplete(() => loadData());
      change(null, status: RxStatus.empty());
    }
  }

  Future<void> filterbyCategory() async {
    log('category');
    log('budget');
    change(null, status: RxStatus.loading());

    final ApiResponse<List<PackageModel>> res =
        await FilterRepository().getCategory(selectedCategoryList);
    if (res.status == ApiResponseStatus.completed) {
      Get.toNamed(Routes.TOURS_VIEW, arguments: res.data)!
          .whenComplete(() => loadData());
      selectedCategories.clear();
      change(null, status: RxStatus.success());
    } else {
      Get.to(
        const Scaffold(
          appBar: CustomAppBar(),
          body: Center(
            child: CustomErrorScreen(
              errorText: 'sorry Nothing \n Found here',
            ),
          ),
        ),
      )!
          .whenComplete(() => loadData());
      change(null, status: RxStatus.empty());
    }
  }

  Future<void> filterbyDuration() async {
    change(null, status: RxStatus.loading());

    final ApiResponse<List<PackageModel>> res =
        await FilterRepository().getToursByDuration(duration.value);
    if (res.status == ApiResponseStatus.completed) {
      Get.toNamed(Routes.TOURS_VIEW, arguments: res.data)!
          .whenComplete(() => loadData());
      change(null, status: RxStatus.success());
    } else {
      Get.to(
        const Scaffold(
          appBar: CustomAppBar(),
          body: Center(
            child: CustomErrorScreen(
              errorText: 'sorry Nothing \n Found here',
            ),
          ),
        ),
      )!
          .whenComplete(() => loadData());
      change(null, status: RxStatus.empty());
    }
  }

  void onDestinationCheck(bool? value, int index) {
    isSelectedDestinations[index] = value ?? false;

    if (value != null && value) {
      if (selectedDestinations.length < 5) {
        selectedDestinations.add(destinationList[index]);
        final DestinationsModel res = selectedDestinations.last;
        log('last selected destination: $res');
      } else {
        // Automatically remove the first selected item
        final DestinationsModel removedItem = selectedDestinations.removeAt(0);
        isSelectedDestinations[destinationList.indexOf(removedItem)] = false;
        // Add the newly selected item to the end of the list
        selectedDestinations.add(destinationList[index]);
      }

      // If "Show Domestic Tours" is selected, clear it
      if (showDomesticTours.value) {
        showDomesticTours.value = false;
      }
    } else {
      selectedDestinations.remove(destinationList[index]);
    }

    printSelectedDestinations();
  }

  void onCategoryCheck(bool? value, int index) {
    isSelectedCategories[index] = value ?? false;
    if (value != null && value) {
      if (selectedCategories.length < 5) {
        selectedCategories.add(categoryList[index]);
        final CategoryModel res = selectedCategories.last;
        log('last selected destination: $res');
      } else {
        // Automatically remove the first selected item
        final CategoryModel removedItem = selectedCategories.removeAt(0);
        isSelectedCategories[categoryList.indexOf(removedItem)] = false;
        // Add the newly selected item to the end of the list
        selectedCategories.add(categoryList[index]);
      }
    }
    update(); // Update the isSelected list
    printSelectedCategories();
  }

  void onBudgetCheck(bool? value, Budget budget) {
    if (value ?? false) {
      selectedBudget.value = budget;
      log(selectedBudget.value.value);
    }
  }

  void printSelectedCategories() {
    selectedCategoryList =
        selectedCategories.map((CategoryModel d) => d.name).join(',');
    log('Selected category: $selectedCategoryList');
  }

  void printSelectedDestinations() {
    selectedDestinationsList = selectedDestinations
        .map((DestinationsModel d) => d.destination)
        .join(',');
    log('Selected category: $selectedDestinationsList');
  }
}

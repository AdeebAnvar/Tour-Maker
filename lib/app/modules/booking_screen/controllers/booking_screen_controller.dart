import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/network_models/booking_model.dart';
import '../../../data/repo/network_repo/booking_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../views/booking_screen_view.dart';

class BookingScreenController extends GetxController
    with StateMixin<BookingScreenView>, GetSingleTickerProviderStateMixin {
  late final TabController tabcontroller =
      TabController(length: 3, vsync: this);
  RxBool isLoading = false.obs;
  RxList<BookingsModel> upcomingList = <BookingsModel>[].obs;
  RxList<BookingsModel> completedList = <BookingsModel>[].obs;
  RxList<BookingsModel> cancelledList = <BookingsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await getAllUpcomingBookings();
    await getAllCompletedBookings();
    await getAllCancelledBookings();
    change(null, status: RxStatus.success());
  }

  void onTapUpcoming() {
    tabcontroller.animateTo(1);
  }

  void onTapCompleted() {
    tabcontroller.animateTo(1);
  }

  void onTapCancelled() {
    tabcontroller.animateTo(1);
  }

  Future<void> getAllUpcomingBookings() async {
    isLoading.value = true;

    final ApiResponse<List<BookingsModel>> res =
        await BookingRepository().getAllBookings('pending');
    if (res.data != null) {
      upcomingList.value = res.data!;
    }
    isLoading.value = false;
  }

  Future<void> getAllCompletedBookings() async {
    isLoading.value = true;

    final ApiResponse<List<BookingsModel>> res =
        await BookingRepository().getAllBookings('confirm');
    if (res.data != null) {
      completedList.value = res.data!;
    }
    isLoading.value = false;
  }

  Future<void> getAllCancelledBookings() async {
    isLoading.value = true;

    final ApiResponse<List<BookingsModel>> res =
        await BookingRepository().getAllBookings('cancelled');
    if (res.data != null) {
      cancelledList.value = res.data!;
    }
    isLoading.value = false;
  }

  num getTotalTravellers(num adults, num childrens) {
    final num sum = adults + childrens;
    return sum;
  }

  String getBookingDate(String dateofTravel) {
    final DateTime inputDate = DateTime.parse(dateofTravel);
    final DateFormat outputFormat = DateFormat('d MMM yy');
    final String formattedDate = outputFormat.format(inputDate);
    return formattedDate;
  }

  void onTapSingleUpComingBooking(BookingsModel upcomingList) {
    Get.toNamed(Routes.BOOKING_SUMMARY, arguments: upcomingList.id)!
        .whenComplete(() => loadData());
  }

  void onTapUpcomingBookingTravellers(BookingsModel upcomingList) {
    Get.toNamed(Routes.TRAVELLERS_SCREEN, arguments: upcomingList.id)!
        .whenComplete(() => loadData());
  }

  void onTapSingleCompletedBooking(BookingsModel completedList) {
    Get.toNamed(Routes.BOOKING_SUMMARY, arguments: completedList.id)!
        .whenComplete(() => loadData());
  }

  void onTapCompleteddBookingTravellers(BookingsModel completedList) {
    Get.toNamed(Routes.TRAVELLERS_SCREEN, arguments: completedList.id)!
        .whenComplete(() => loadData());
  }

  void onTapSingleCancelledBooking(BookingsModel cancelledList) {
    Get.toNamed(Routes.BOOKING_SUMMARY, arguments: cancelledList.id)!
        .whenComplete(() => loadData());
  }

  void onTapCancelledBookingTravellers(BookingsModel cancelledList) {
    Get.toNamed(Routes.TRAVELLERS_SCREEN, arguments: cancelledList.id)!
        .whenComplete(() => loadData());
  }
}

import 'package:get/get.dart';

import '../controllers/booking_summary_controller.dart';

class BookingSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingSummaryController>(
      () => BookingSummaryController(),
    );
  }
}

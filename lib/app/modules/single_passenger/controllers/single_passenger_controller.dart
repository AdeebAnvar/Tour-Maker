import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../data/models/network_models/travellers_model.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/single_passenger_view.dart';

class SinglePassengerController extends GetxController
    with StateMixin<SinglePassengerView> {
  RxList<TravellersModel> passenger = <TravellersModel>[].obs;
  int? id;
  // String? adhar;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      id = Get.arguments as int;
      await loadPasenger(id);

      change(null, status: RxStatus.success());
    }
  }

  Future<void> loadPasenger(int? id) async {
    final ApiResponse<List<TravellersModel>> res =
        await PassengerRepository().getSinglePassenger(id!);
    try {
      if (res.data != null) {
        passenger.value = res.data!;
        // await loadAAdhar(passenger[0].name!, passenger[0].orderId!);
      } else {}
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  // Future<void> loadAAdhar(String name, int orderid) async {
  //   final ApiResponse<dynamic> res =
  //       await PassengerRepository().getadhar(name, orderid);
  //   try {
  //     if (res.data != null) {
  //       adhar = res.data as String;
  //     } else {}
  //   } catch (e) {
  //     CustomDialog().showCustomDialog('Error !', contentText: e.toString());
  //   }
  // }

  // Uint8List getImageFromBytes() {
  //   final String base64Image = adhar.toString();
  //   final Uint8List bytes = base64.decode(base64Image.split(',').last);
  //   return bytes;
  // }
}

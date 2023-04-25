// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/utils/constants.dart';

import '../../../data/models/network_models/razorpay_model.dart';
import '../../../data/repo/network_repo/razorpay_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';

class LuckyDrawController extends GetxController {
  dynamic userName;

  String tokenText =
      '''Welcome $currentUserName!\nGet ready for a chance to win big!\nwe're excited to announce that once we reach 10,000 users, we'll be conducting a lucky draw contest.\nstay tuned for more information on how to participate and the prizes you can win.\nin the meantime, invite your friends and family to join the app and increase your chances of being one of the lucky winners. \n LET'S REACH OUR GOAL TOGETHER!  ''';
  final RxInt count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isFinished = false.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

  String typewriterAudio = 'assets/typewriter-1.mp3';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    log('hello');

    playAudio();
  }

  @override
  void onClose() {
    super.onClose();
    audioPlayer.dispose();
  }

  Future<void> playAudio() async {
    await audioPlayer.play(AssetSource('typewriter-1.mp3'));
  }

  Future<void> onFinished() async {
    isFinished.value = true;
    await audioPlayer.pause();
  }

  void onClickDemoApp() {
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> onClickPayment() async {}

  void showRegisterBttomSheet(String name, String state, String phoneNumber) {
    Get.offAllNamed(Routes.USER_REGISTERSCREEN,
        arguments: <String>[name, state, phoneNumber]);
  }
}

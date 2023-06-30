import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/lucky_draw_view.dart';

class LuckyDrawController extends GetxController
    with StateMixin<LuckyDrawView> {
  dynamic userName;
  String? currentUserName;
  final RxInt count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isloading = false.obs;
  RxBool isClickNext = false.obs;
  // RxBool isFinished = false.obs;
  // RxBool isFinishedHeading = false.obs;
  final GetStorage getStorage = GetStorage();
  final AudioPlayer audioPlayer = AudioPlayer();

  String typewriterAudio = 'assets/typewriter-1.mp3';

  @override
  Future<void> onInit() async {
    super.onInit();
    change(null, status: RxStatus.success());
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // playAudio();
  }

  Future<void> playAudio() async {
    await audioPlayer.play(AssetSource('typewriter-1.mp3'));
  }

  // Future<void> onFinished() async {
  //   isFinished.value = true;
  //   await audioPlayer.pause();
  // }

  void onClickDemoApp() {
    Get.offAllNamed(Routes.HOME);
  }

  // Future<void> onFinishedHeading() async {
  //   isFinishedHeading.value = true;
  // }

  Future<void> onClickFoatingButton() async {
    CustomDialog().showCustomDialog(
      barrierDismissible: false,
      'Want to Suggest A Friend',
      confirmText: 'NO',
      cancelText: 'Suggest',
      onCancel: () async {
        Get.back();
        Get.offAllNamed(Routes.SUGGEST_FRIEND);
      },
      onConfirm: () {
        Get.offAllNamed(Routes.HOME);
      },
    );
  }

  void onClickNext() {
    isLoading.value = true;
    isClickNext.value = true;
  }
}

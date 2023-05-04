import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class LuckyDrawController extends GetxController with StateMixin<dynamic> {
  dynamic userName;
  String? currentUserName;
  final RxInt count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isFinished = false.obs;
  final GetStorage getStorage = GetStorage();
  final AudioPlayer audioPlayer = AudioPlayer();

  String typewriterAudio = 'assets/typewriter-1.mp3';

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    change(null, status: RxStatus.loading());
    currentUserName = await getStorage.read('currentUserName') as String;
    change(null, status: RxStatus.success());
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

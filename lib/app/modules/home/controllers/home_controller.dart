import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  PageController pageViewController = PageController();
  final int initialPage = 0;
  RxInt currentIndex = 0.obs;

  void onTapNavigationBar(int index) {
    pageViewController.animateToPage(index,
        duration: const Duration(microseconds: 500), curve: Curves.ease);
    currentIndex.value = index;
  }

  int onPageViewChanged(int value) {
    return currentIndex.value = value;
  }
}

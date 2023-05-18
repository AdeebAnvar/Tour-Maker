import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../controllers/rewards_controller.dart';

class RewardsView extends GetView<RewardsController> {
  const RewardsView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: Text('Rewards')),
      body: CustomErrorScreen(
        errorText: 'No rewards',
      ),
    );
  }
}

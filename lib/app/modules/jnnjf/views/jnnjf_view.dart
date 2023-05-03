import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/jnnjf_controller.dart';

class JnnjfView extends GetView<JnnjfController> {
  const JnnjfView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JnnjfView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JnnjfView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

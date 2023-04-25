import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/local_model/checkout_model.dart';

class CheckOutRepositoy {
  static Future<void> saveData(CheckOutModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String modelJson = jsonEncode(model.toMap());
    await prefs.setString('checkout_data', modelJson);
  }

  static Future<CheckOutModel?> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? modelJson = prefs.getString('checkout_data');
    if (modelJson != null) {
      final Map<String, dynamic> modelMap =
          jsonDecode(modelJson) as Map<String, dynamic>;
      return CheckOutModel.fromMap(modelMap);
    } else {
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/style.dart';
import '../../core/tour_maker_icons.dart';

class CustomDropDownButton extends StatelessWidget {
  CustomDropDownButton({
    super.key,
    required this.lists,
    required this.onChange,
    EdgeInsets? padding,
    String? initialValue,
  })  : padding = padding ?? const EdgeInsets.symmetric(vertical: 10.0),
        initialValue = initialValue ?? lists[0];
  final List<String> lists;
  final Function(int index, String value) onChange;
  final EdgeInsets padding;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    final int initValueIndex = lists.indexOf(initialValue);
    final RxString selectedItem = '$initValueIndex# $initialValue'.obs;
    return Padding(
      padding: padding,
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 232, 231, 233),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 29.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
        child: DropdownButtonHideUnderline(
          child: Obx(
            () => DropdownButton<String>(
              style: paragraph3,
              icon: const Icon(TourMaker.arrow___down_3, size: 9),
              value: selectedItem.value,
              items: lists
                  .asMap()
                  .map(
                    (int i, String e) =>
                        MapEntry<int, DropdownMenuItem<String>>(
                      i,
                      DropdownMenuItem<String>(
                        value: '$i# $e',
                        child: Text(e),
                      ),
                    ),
                  )
                  .values
                  .toList(),
              onChanged: (String? value) {
                selectedItem.value = value!;
                final int ind = int.parse(value.split('#')[0]);
                final String val = value.split('#')[1].trim();
                onChange(ind, val);
              },
            ),
          ),
        ),
      ),
    );
  }
}

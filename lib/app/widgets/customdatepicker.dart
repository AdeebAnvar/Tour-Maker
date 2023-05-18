import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme/style.dart';
import '../../core/tour_maker_icons.dart';

class CustomDatePickerField extends StatelessWidget {
  const CustomDatePickerField({
    super.key,
    required this.labelName,
    required this.validator,
    required this.onChange,
    this.maxLines,
    this.inputType,
    bool? isTime,
    EdgeInsets? padding,
    String? initialValue,
  })  : padding = padding ?? const EdgeInsets.symmetric(vertical: 8.0),
        isTime = isTime ?? false,
        initialValue = initialValue ?? ' ';
  final String labelName;
  final String? Function(String? value) validator;
  final Function(String value) onChange;
  final int? maxLines;
  final TextInputType? inputType;
  final bool isTime;
  final String initialValue;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          DateTimePicker(
            calendarTitle: 'DATE OF BIRTH',

            dateMask: 'dd-MM-yyyy',
            // use24HourFormat: false,

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(30),
              filled: true,
              fillColor: const Color.fromARGB(255, 232, 231, 233),
              hintText: labelName,
              suffixIcon: Icon(
                TourMaker.calendar,
                color: fontColor,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            initialValue: initialValue,

            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            onChanged: onChange,
            validator: validator,
          ),
        ],
      ),
    );
  }
}

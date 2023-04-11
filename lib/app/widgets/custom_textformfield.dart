import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.keyboardType,
    this.textInputAction,
    required this.onChanged,
    required this.validator,
    required this.hintText,
    this.prefixIcon,
    this.maxLines,
    this.minLines,
    this.initialValue,
    this.controller,
    this.enabled,
  });
  final int? maxLines;
  final bool? enabled;
  final TextEditingController? controller;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String) onChanged;
  final String? Function(String?) validator;
  final String hintText;
  final String? initialValue;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      initialValue: initialValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(30),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
//Padding(
        //   padding: const EdgeInsets.only(left: 8.0),
        //   child: Icon(
        //     TourMaker.profile_icon,
        //     color: fontColor,
        //   ),
        // ),
        

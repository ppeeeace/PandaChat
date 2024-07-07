import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hint,
    this.iconn,
    this.textType,
    this.hideText = false,
    this.onChanged,
    this.controller,
    this.validate,
  });
  final String? hint;
  final IconData? iconn;
  final TextInputType? textType;
  final bool? hideText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      validator: validate,
      textCapitalization: TextCapitalization.words,
      cursorColor: kSecondaryColor,
      keyboardType: textType,
      obscureText: hideText!,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          iconn,
          color: kSecondaryColor,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kSecondaryColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kSecondaryColor),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: kSecondaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

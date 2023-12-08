import 'package:flutter/material.dart';

Widget customTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String hintText,
  bool autofocus = false,
  bool obscureText = false,
  int? maxLength,
  int? maxLines = 1,
  String? Function(String?)? validator,
  Widget? prefixIcon,
  Widget? suffixIcon,
  AutovalidateMode? autovalidateMode,
  String? labelText,
  TextInputAction? textInputAction,
  void Function(String)? onChanged,
  bool? enabled,
}) =>
    TextFormField(
      enabled: enabled,
      enableSuggestions: true,
      onChanged: onChanged,
      autofocus: autofocus,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      autovalidateMode: autovalidateMode,
      validator: validator,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 18,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      ),
    );

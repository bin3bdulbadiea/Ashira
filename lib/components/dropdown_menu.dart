import 'package:flutter/material.dart';

Widget customDropdownMenuItem({
  required BuildContext context,
  String? Function(String?)? validator,
  required String hintText,
  String? labelText,
  required String? value,
  required void Function(String?)? onChanged,
  required List<DropdownMenuItem<String>>? items,
}) =>
    DropdownButtonFormField<String>(
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 18,
        ),
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
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
      ),
      value: value,
      onChanged: onChanged,
      items: items,
    );

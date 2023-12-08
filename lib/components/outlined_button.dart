import 'package:flutter/material.dart';

OutlinedButton customOutlinedButton(
  BuildContext context, {
  required void Function() onPressed,
  required String text,
}) =>
    OutlinedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(
          Theme.of(context).colorScheme.onPrimary,
        ),
        overlayColor: const MaterialStatePropertyAll(
          Colors.grey,
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );

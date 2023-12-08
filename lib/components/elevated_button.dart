import 'package:flutter/material.dart';

Widget customElevatedButton({
  required BuildContext context,
  required void Function()? onPressed,
  required String text,
}) =>
    ElevatedButton(
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
        backgroundColor: MaterialStatePropertyAll(
          Theme.of(context).colorScheme.onBackground,
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        overlayColor: MaterialStatePropertyAll(Colors.grey[700]),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );

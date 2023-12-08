// أيقونة توثيق الحساب
import 'package:flutter/material.dart';

OutlinedButton outlinedButtonToVerifyAccount(
  BuildContext context,
  Size size, {
  required void Function()? onPressed,
  required Color iconColor,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            size: 16,
            color: iconColor,
          ),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );

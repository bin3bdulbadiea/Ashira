import 'package:ashira/generated/l10n.dart';
import 'package:flutter/material.dart';

class AppLogoOutSide extends StatelessWidget {
  const AppLogoOutSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'عشيرة',
          style: TextStyle(
            fontFamily: 'Ruwudu',
            fontSize: 50,
          ),
        ),
        Text(
          S.of(context).beta,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}

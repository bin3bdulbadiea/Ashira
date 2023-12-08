import 'package:ashira/layouts/menu_drawer/languages_screen.dart';
import 'package:flutter/material.dart';

class ChangeAppLanguage extends StatelessWidget {
  const ChangeAppLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LanguagesScreen(),
          ),
        );
      },
      icon: const Icon(Icons.language),
    );
  }
}
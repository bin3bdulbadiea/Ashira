import 'package:ashira/generated/l10n.dart';
import 'package:ashira/controllers/menu_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).chooseLanguage),
      ),
      body: GetBuilder(
        init: MenuDrawerController(),
        builder: (controller) => ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) => ListTile(
            title: Text(index == 0 ? 'العربية' : 'English'),
            onTap: () {
              controller.changeLocale(index == 0 ? 'ar' : 'en');
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}

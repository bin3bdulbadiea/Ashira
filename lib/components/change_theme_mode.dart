import 'package:ashira/controllers/menu_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ChangeThemeMode extends StatelessWidget {
  const ChangeThemeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MenuDrawerController(),
      builder: (controller) => IconButton(
        onPressed: () {
          controller.changeThemeMode();
        },
        icon: Icon(
          controller.isNight.value ? Icons.light_mode : Icons.mode_night,
        ),
      ),
    );
  }
}
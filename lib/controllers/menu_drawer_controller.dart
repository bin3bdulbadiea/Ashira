import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuDrawerController extends GetxController {
  RxBool isNight = false.obs;
  Rx<Locale> selectedLocale = const Locale('ar').obs;

  @override
  void onInit() {
    super.onInit();
    loadMode();
  }

  // تغيير المظهر
  void loadMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isNight.value = prefs.getBool('isNight') ?? true;
    selectedLocale.value = Locale(prefs.getString('locale') ?? 'ar');
  }

  void changeThemeMode() async {
    isNight.value = !isNight.value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isNight', isNight.value);
    update();
  }

  void changeLocale(String languageCode) async {
    selectedLocale.value = Locale(languageCode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', languageCode);
    update();
  }
}

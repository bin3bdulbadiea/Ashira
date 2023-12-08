import 'package:ashira/screens/account_screen/account_screen.dart';
import 'package:ashira/screens/messages_screen/messages_screen.dart';
import 'package:ashira/screens/friends_screen/friends_screen.dart';
import 'package:ashira/screens/home_screen/home_screen.dart';
import 'package:ashira/screens/notifications_screen/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayoutController extends GetxController {
  // bottom nav bar
  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const NotificationsScreen(),
    MessagesScreen(),
    const FriendsScreen(),
    const AccountScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    update();
  }
}

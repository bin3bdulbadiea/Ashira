// ignore_for_file: use_build_context_synchronously

import 'package:ashira/controllers/post_controller.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/components/check_internet/check_internet.dart';
import 'package:ashira/controllers/home_layout_controller.dart';
import 'package:ashira/layouts/menu_drawer/menu_drawer.dart';
import 'package:ashira/layouts/post_screen/post_screen.dart';
import 'package:ashira/layouts/search/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLayoutController>(
      init: HomeLayoutController(),
      builder: (controller) {
        return FutureBuilder(
          future: Connectivity().checkConnectivity(),
          builder: (context, snapshot) {
            // اختبار وجود الإنترنت من عدمه
            if (snapshot.data == ConnectivityResult.none) {
              return CheckInternet(
                controllerPressed: () => controller.update(),
              );
            } else {
              // إجبار جميع الصفحات إلى التوجه إلى الصفحة الرئيسية
              return WillPopScope(
                onWillPop: () async {
                  if (controller.currentIndex != 0) {
                    controller.changeBottomNavBar(0);
                    return false;
                  }
                  return true;
                },
                child: Scaffold(
                  appBar: AppBar(
                    // شعار التطبيق
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'عشيرة',
                          style: TextStyle(
                            fontFamily: 'Ruwudu',
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          S.of(context).beta,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      // أيقونة إضافة منشور
                      IconButton(
                        onPressed: () {
                          var postController = Get.put(PostController());

                          postController.selectedPostMedia = null;
                          postController.postController.clear();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostScreen(),
                            ),
                          );
                        },
                        icon: Image.asset(
                          'assets/icons/add.png',
                          width: 25,
                          height: 25,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),

                      // أيقونة البحث
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.search),
                        iconSize: 25,
                      ),
                    ],
                  ),

                  // القائمة الجانبية
                  drawer: const MenuDrawer(),

                  // التنقل بين الصفحات
                  body: controller.screens[controller.currentIndex],

                  // القوائم الموجودة أسفل الصفحة
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Theme.of(context).colorScheme.onPrimary,
                    unselectedItemColor:
                        Theme.of(context).colorScheme.onSecondary,
                    currentIndex: controller.currentIndex,
                    onTap: (value) {
                      controller.changeBottomNavBar(value);
                    },
                    items: [
                      // الرئيسية
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.home),
                        label: S.of(context).home,
                      ),

                      // الإشعارات
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.notifications),
                        label: S.of(context).notifications,
                      ),

                      // الرسائل
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.message),
                        label: S.of(context).messages,
                      ),

                      // الأصدقاء
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.group),
                        label: S.of(context).friends,
                      ),

                      // الحساب
                      BottomNavigationBarItem(
                        icon: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where(
                                'id',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid,
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            return CircleAvatar(
                              radius: 14,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              child: snapshot.data?.docs[0]['photoURL'] == ''
                                  ? const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.person, size: 20),
                                    )
                                  : CircleAvatar(
                                      radius: 12,
                                      foregroundImage: NetworkImage(
                                        '${snapshot.data?.docs[0]['photoURL']}',
                                      ),
                                    ),
                            );
                          },
                        ),
                        label: S.of(context).account,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

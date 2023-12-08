import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/controllers/home_layout_controller.dart';
import 'package:ashira/controllers/menu_drawer_controller.dart';
import 'package:ashira/layouts/menu_drawer/languages_screen.dart';
import 'package:ashira/layouts/menu_drawer/screens/ads.dart';
import 'package:ashira/layouts/menu_drawer/screens/channels.dart';
import 'package:ashira/layouts/menu_drawer/screens/groups.dart';
import 'package:ashira/layouts/menu_drawer/screens/jobs.dart';
import 'package:ashira/layouts/menu_drawer/screens/market.dart';
import 'package:ashira/layouts/menu_drawer/screens/pages.dart';
import 'package:ashira/layouts/menu_drawer/screens/saved_items.dart';
import 'package:ashira/layouts/menu_drawer/screens/videos.dart';
import 'package:ashira/layouts/search/search.dart';
import 'package:ashira/screens/auth_screens/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeLayoutController());

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    // العنوان بالأعلى: القائمة
                    Text(
                      S.of(context).menu,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    // أيقونة البحث
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search),
                    ),

                    // أيقونة تغيير المظهر
                    GetBuilder(
                      init: MenuDrawerController(),
                      builder: (controller) => IconButton(
                        onPressed: () {
                          controller.changeThemeMode();
                        },
                        icon: Icon(
                          controller.isNight.value
                              ? Icons.light_mode
                              : Icons.mode_night,
                        ),
                      ),
                    ),

                    // أيقونة تغيير اللغة
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LanguagesScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.language),
                    ),
                  ],
                ),
              ),
            ),

            // عرض الحساب
            displayAccount(homeController),

            // أيقونات الانتقال السريع
            // الإشعارات & الرسائل & الأصدقاء
            iconsForTransfairSpeed(context, homeController),

            // قائمة الفروع
            // القنوات & الصفحات & المجموعات & السوق & العلوم & الوظائف & الإعلانات & مقاطع الفيديو & العناصر المحفوظة
            listOfBranches(context),

            const Divider(color: Colors.grey),

            // تسجيل الخروج
            signOut(context, homeController),
          ],
        ),
      ),
    );
  }

  Padding signOut(BuildContext context, HomeLayoutController homeController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: customListTileToMenuDrawer(
        icon: const Icon(Icons.logout),
        iconColor: Colors.purple.shade700,
        title: Text(S.of(context).signout),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(S.of(context).signout),
              content: Text(S.of(context).wantSignout),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut().then(
                          (value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false,
                          ),
                        );

                    if (homeController.currentIndex != 0) {
                      homeController.changeBottomNavBar(0);
                    }
                  },
                  child: Text(S.of(context).signout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Expanded listOfBranches(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        physics: const BouncingScrollPhysics(),
        children: [
          // العناصر المحفوظة: لحفظ المنشورات والمقاطع
          customListTileToMenuDrawer(
            icon: const Icon(Icons.bookmark),
            iconColor: Colors.red.shade300,
            title: Text(S.of(context).savedItems),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedItemsScreen(),
                ),
              );
            },
          ),

          // القنوات: تكون للأخبار العاجلة والساخنة، بحيث يتم إرسال إشعارات للمشتركين فيها للمنشورات
          customListTileToMenuDrawer(
            icon: const Icon(Icons.newspaper),
            iconColor: Colors.teal,
            title: Text(S.of(context).channels),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChannelsScreen(),
                ),
              );
            },
          ),

          // الصفحات: تكون للنشر العادي الذي ليس فيه إشعارات، وقد تظهر منشوراتها للمتابعين وقد لا تظهر
          customListTileToMenuDrawer(
            icon: const Icon(Icons.flag),
            iconColor: Colors.green,
            title: Text(S.of(context).pages),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PagesScreen(),
                ),
              );
            },
          ),

          // المجموعات: تكون للتواصل بين مجموعة من الناس في قضايا معينة تخصهم وحدهم
          customListTileToMenuDrawer(
            icon: const Icon(Icons.groups),
            iconColor: Colors.blue,
            title: Text(S.of(context).groups),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupsScreen(),
                ),
              );
            },
          ),

          // السوق: للبيع والشراء بين الناس
          customListTileToMenuDrawer(
            icon: const Icon(Icons.shopping_bag),
            iconColor: Colors.orange,
            title: Text(S.of(context).market),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MarketScreen(),
                ),
              );
            },
          ),

          // العلوم: لطلب العلوم الشرعية والعلوم الدنيوية
          // customListTileToMenuDrawer(
          //   icon: const Icon(Icons.science),
          //   iconColor: Colors.pink,
          //   title: Text(S.of(context).sciences),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const SciencesScreen(),
          //       ),
          //     );
          //   },
          // ),

          ExpansionTile(
            leading: const Icon(Icons.science, color: Colors.pink),
            title: const Text('العلوم'),
            children: [
              ListTile(
                onTap: () {},
                title: const Text('العلوم الشرعية'),
              ),
              ListTile(
                onTap: () {},
                title: const Text('العلوم التطبيقية'),
              ),
            ],
          ),

          // الوظائف: للبحث عن الوظائف المتاحة في كافة المجالات ونشر إعلان عن وظيفة متاحة
          customListTileToMenuDrawer(
            icon: const Icon(Icons.cases_rounded),
            iconColor: Colors.amber,
            title: Text(S.of(context).jobs),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobsScreen(),
                ),
              );
            },
          ),

          // الإعلانات: لعمل الإعلانات الممولة
          customListTileToMenuDrawer(
            icon: const Icon(Icons.campaign),
            iconColor: Colors.pink.shade900,
            title: Text(S.of(context).ads),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdsScreen(),
                ),
              );
            },
          ),

          // مقاطع الفيديو: لعمل مقاطع فيديو ومشاهدتها
          customListTileToMenuDrawer(
            icon: const Icon(Icons.video_collection),
            iconColor: Colors.blue.shade300,
            title: Text(S.of(context).videos),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VideosScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Row iconsForTransfairSpeed(
      BuildContext context, HomeLayoutController homeController) {
    return Row(
      children: [
        // الإشعارات
        Expanded(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              if (homeController.currentIndex != 1) {
                homeController.changeBottomNavBar(1);
              }
            },
            icon: const Icon(Icons.notifications),
          ),
        ),

        // الرسائل
        Expanded(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              if (homeController.currentIndex != 2) {
                homeController.changeBottomNavBar(2);
              }
            },
            icon: const Icon(Icons.message),
          ),
        ),

        // الأصدقاء
        Expanded(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              if (homeController.currentIndex != 3) {
                homeController.changeBottomNavBar(3);
              }
            },
            icon: const Icon(Icons.group),
          ),
        ),
      ],
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> displayAccount(
      HomeLayoutController homeController) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where(
            'id',
            isEqualTo: FirebaseAuth.instance.currentUser?.uid,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return customCircularProgressIndicator(context);
        }

        var data = snapshot.data?.docs;

        // عرض الحساب حتى يتمكن المستخدم من عرض حسابه الشخصي
        var photoURL = data?[0]['photoURL'];

        return Column(
          children: [
            customListTileToMenuDrawer(
              icon: photoURL == null || photoURL.isEmpty
                  ? const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 30),
                    )
                  : CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        '${data?[0]['photoURL']}',
                      ),
                    ),
              title: Row(
                children: [
                  Text(
                    '${data?[0]['name']} ${data?[0]['last-name']}',
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  data?[0]['account-verified'] == false
                      ? const SizedBox.shrink()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                  data?[0]['account-verified'] == false
                      ? const SizedBox.shrink()
                      : Icon(
                          Icons.verified,
                          color: Colors.green[700],
                          size: 13,
                        ),
                ],
              ),
              subtitle: Text(
                S.of(context).viewAccount,
                style: const TextStyle(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (homeController.currentIndex != 4) {
                  homeController.changeBottomNavBar(4);
                }
              },
            ),
          ],
        );
      },
    );
  }

  ListTile customListTileToMenuDrawer({
    required Widget icon,
    Color? iconColor,
    required Widget title,
    Widget? subtitle,
    required void Function() onTap,
  }) =>
      ListTile(
        leading: icon,
        iconColor: iconColor,
        title: title,
        subtitle: subtitle,
        onTap: onTap,
      );
}

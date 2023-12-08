// ignore_for_file: depend_on_referenced_packages

import 'package:ashira/components/build_post_item.dart';
import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/components/expandImage.dart';
import 'package:ashira/components/outlined_button.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/screens/account_screen/change_account/change_account.dart';
import 'package:ashira/controllers/account_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final dateFormat = DateFormat('dd - MMMM - yyyy');

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

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الصورة الشخصية
              FutureBuilder(
                future: precacheImage(
                  NetworkImage('${data?[0]['photoURL']}'),
                  context,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text(
                        S.of(context).loadingImage,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return displayPersonaLImage(data, context);
                  } else {
                    return Center(
                      child: Text(
                        S.of(context).errorLoadingImage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
              ),

              SizedBox(height: size.height * 0.01),

              // معلومات المستخدم
              personalData(data, size, context),

              SizedBox(height: size.height * 0.01),

              // نبذة عنك
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  data?[0]['bio'] == '' ? S.of(context).noBio : data?[0]['bio'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // إعدادات الحساب
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: accountSettings(context, data, dateFormat),
              ),

              SizedBox(height: size.height * 0.02),

              // منشوراتي
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    S.of(context).myPosts,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    // .orderBy('post-date', descending: true)
                    .where(
                      'user-id',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return customCircularProgressIndicator(context);
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text(S.of(context).noPosts));
                  }

                  var postData = snapshot.data!.docs;

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

                      var userData = snapshot.data?.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        itemCount: postData.length,
                        itemBuilder: (context, index) => buildPostItem(
                          context,
                          index,
                          size,
                          postData: postData,
                          userData: userData?[0],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Expanded accountSettings(BuildContext context,
      List<QueryDocumentSnapshot<Object?>>? data, DateFormat dateFormat) {
    return Expanded(
      child: customOutlinedButton(
        context,
        onPressed: () {
          Get.put(AccountController()).nameController.text = data?[0]['name'];
          Get.put(AccountController()).lastNameController.text =
              data?[0]['last-name'];
          Get.put(AccountController()).nickNameController.text =
              data?[0]['nick-name'];
          Get.put(AccountController()).bioController.text = data?[0]['bio'];
          Get.put(AccountController()).gender = data?[0]['gender'];
          Get.put(AccountController()).maritalStatus =
              data?[0]['marital-status'];
          Get.put(AccountController()).selectedDate =
              data?[0]['birthdate'].toDate();
          Get.put(AccountController()).dateController.text =
              dateFormat.format(data?[0]['birthdate'].toDate());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeAccount(data: data),
            ),
          );
        },
        text: S.of(context).accountSettings,
      ),
    );
  }

  Row personalData(
    List<QueryDocumentSnapshot<Object?>>? data,
    Size size,
    BuildContext context,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              data?[0]['name'] + ' ' + data?[0]['last-name'],
              maxLines: 2,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                height: 1.5,
                fontSize: 22,
              ),
            ),
          ),
          data?[0]['nick-name'] == ''
              ? const SizedBox.shrink()
              : SizedBox(width: size.width * 0.01),
          data?[0]['nick-name'] == ''
              ? const SizedBox.shrink()
              : Text('(${data?[0]['nick-name']})'),
          SizedBox(width: size.width * 0.01),
          if (data?[0]['account-verified'])
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  isDismissible: true,
                  showDragHandle: true,
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: verifiedAccount(data, size, context),
                  ),
                );
              },
              child: Icon(Icons.verified, color: Colors.green.shade700),
            ),
        ],
      );

  Column verifiedAccount(
    List<QueryDocumentSnapshot<Object?>>? data,
    Size size,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // بيانات المستخدم
        Row(
          children: [
            // صورة الملف الشخصي
            data?[0]['photoURL'] == ''
                ? const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      '${data?[0]['photoURL']}',
                    ),
                  ),

            SizedBox(width: size.width * 0.02),

            // اسم المستخدم
            Flexible(
              child: Text(
                data?[0]['name'] + ' ' + data?[0]['last-name'],
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  height: 1.5,
                  fontSize: 15,
                ),
              ),
            ),

            SizedBox(width: size.width * 0.02),

            // أيقونة التوثيق
            Icon(
              Icons.verified,
              size: 15,
              color: Colors.green.shade700,
            ),
          ],
        ),

        SizedBox(height: size.height * 0.02),

        // رسالة التوثيق
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أيقونة التوثيق
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Icon(
                Icons.verified,
                size: 15,
              ),
            ),
            SizedBox(width: size.width * 0.02),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // حساب مُوثّق
                  Text(
                    S.of(context).verified,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // تم التحقّق من ملكية الحساب لهذا المستخدم عبر الوثائق الشخصية الموثوق بها
                  Text(S.of(context).verifiedAccount),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding displayPersonaLImage(
    List<QueryDocumentSnapshot<Object?>>? data,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          data?[0]['photoURL'] == ''
              ? null
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => expandImage(context, data,
                        image: data?[0]['photoURL'],
                        username: '${data?[0]['full-name']}',
                        userPhoto: '${data?[0]['photoURL']}'),
                  ),
                );
        },
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: data?[0]['photoURL'] == ''
                ? Container(
                    color: Colors.grey,
                    child: const Icon(Icons.person, size: 100),
                  )
                : Image.network(data?[0]['photoURL'], fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}

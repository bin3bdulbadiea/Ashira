import 'package:ashira/components/build_post_item.dart';
import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/components/elevated_button.dart';
import 'package:ashira/components/expandImage.dart';
import 'package:ashira/components/expandable_text.dart';
import 'package:ashira/components/likes_comments_shares/comments_screen.dart';
import 'package:ashira/components/likes_comments_shares/likes_screen.dart';
import 'package:ashira/components/likes_comments_shares/shares_screen.dart';
import 'package:ashira/components/outlined_button.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/controllers/friends_controller.dart';
import 'package:ashira/controllers/home_layout_controller.dart';
import 'package:ashira/controllers/likes_on_posts_controller.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.userData});

  final dynamic userData;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // الصورة الشخصية
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  userData?['photoURL'] == ''
                      ? null
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => expandImage(
                              context,
                              userData,
                              image: userData?['photoURL'],
                              username: '${userData?['full-name']}',
                              userPhoto: '${userData?['photoURL']}',
                            ),
                          ),
                        );
                },
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    child: userData?['photoURL'] == ''
                        ? Container(
                            color: Colors.grey,
                            child: const Icon(Icons.person, size: 100),
                          )
                        : Image.network(userData?['photoURL'],
                            fit: BoxFit.fill),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.01),

            // معلومات المستخدم
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // اسم المستخدم
                Flexible(
                  child: Text(
                    '${userData?['full-name']}',
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      height: 1.5,
                      fontSize: 22,
                    ),
                  ),
                ),

                // مساحة فارغة لإظهار الكُنية / اللقب
                userData?['nick-name'] == ''
                    ? const SizedBox.shrink()
                    : SizedBox(width: size.width * 0.01),

                // الكُنية / اللقب
                userData?['nick-name'] == ''
                    ? const SizedBox.shrink()
                    : Text('(${userData?['nick-name']})'),

                SizedBox(width: size.width * 0.01),

                // الحساب موثق ولا لا
                if (userData?['account-verified'])
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        showDragHandle: true,
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // بيانات المستخدم
                              Row(
                                children: [
                                  // صورة الملف الشخصي
                                  userData?['photoURL'] == ''
                                      ? const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.person, size: 50),
                                        )
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            '${userData?['photoURL']}',
                                          ),
                                        ),

                                  SizedBox(width: size.width * 0.02),

                                  // اسم المستخدم
                                  Flexible(
                                    child: Text(
                                      '${userData?['full-name']}',
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: const Icon(
                                      Icons.verified,
                                      size: 15,
                                    ),
                                  ),

                                  SizedBox(width: size.width * 0.02),

                                  // توثيق
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.verified, color: Colors.green.shade700),
                  ),
              ],
            ),

            SizedBox(height: size.height * 0.01),

            // نبذة عن المستخدم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                userData?['bio'] == '' ? S.of(context).noBio : userData?['bio'],
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            // إضافة صديق & مراسلة & إعدادات
            if (userData?['id'] != FirebaseAuth.instance.currentUser?.uid)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    // إضافة صديق
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where(
                              'id',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          var data = snapshot.data?.docs;

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('friends-requests')
                                .snapshots(),
                            builder: (context, snapshot) {
                              var friendsData = snapshot.data?.docs;

                              var controller = Get.put(FriendsController());
                              return customOutlinedButton(
                                context,
                                onPressed: () {
                                  if (controller.requestDone == true) {
                                    controller.disAddFriend(
                                      docId: friendsData?[0]['doc-id'],
                                    );
                                  } else {
                                    controller.addFriend(
                                      senderId: userData?[0]['id'],
                                      reciverId: data?[0]['id'],
                                    );
                                  }
                                },
                                text: controller.requestDone == true
                                    ? 'قيد الانتظار ...'
                                    : 'إضافة صديق',
                              );
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(width: size.width * 0.02),

                    // مراسلة
                    Expanded(
                      child: customOutlinedButton(
                        context,
                        onPressed: () {},
                        text: 'مراسلة',
                      ),
                    ),

                    // إعدادات
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                        isDismissible: true,
                        showDragHandle: true,
                        context: context,
                        builder: (context) => SizedBox(
                          height: size.height * 0.21,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {},
                                leading: const Icon(Icons.person),
                                title: const Text('معلومات المستخدم'),
                              ),
                              ListTile(
                                onTap: () {},
                                leading: const Icon(Icons.block),
                                title: const Text('حظر'),
                              ),
                              ListTile(
                                onTap: () {},
                                leading: const Icon(Icons.report),
                                title: const Text('إبلاغ'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),

            // الانتقال إلى الحساب الشخصي
            if (userData?['id'] == FirebaseAuth.instance.currentUser?.uid)
              customOutlinedButton(
                context,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Get.put(HomeLayoutController()).changeBottomNavBar(4);
                },
                text: 'الانتقال إلى حسابي',
              ),

            SizedBox(height: size.height * 0.02),

            // المنشورات
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'المنشورات',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where(
                    'user-id',
                    isEqualTo: userData?['id'],
                  )
                  // .orderBy('post-date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return customCircularProgressIndicator(context);
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text(S.of(context).noPosts));
                }

                var postData = snapshot.data?.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  itemCount: postData?.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  userData?['photoURL'] == ''
                                      // إذا كانت الصورة فارغة يتم إظهار أيقونة مكان الصورة
                                      ? const CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.person, size: 30),
                                        )
                                      // إذا كان الصورة موجودة فيتم إظهارها
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                            '${userData['photoURL']}',
                                          ),
                                        ),

                                  SizedBox(width: size.width * 0.05),

                                  // اسم المستخدم & توقيت مشاركة المنشور
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // اسم المستخدم
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${userData['full-name']}',
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: size.width * 0.01),

                                            // بختبر هنا إذا كان الحساب مُوثّق ولا لا
                                            if (userData['account-verified'] ==
                                                true)
                                              Icon(
                                                Icons.verified,
                                                color: Colors.green[700],
                                                size: 13,
                                              ),
                                          ],
                                        ),

                                        // توقيت مشاركة المنشور
                                        Text(
                                          timeago.format(
                                            DateTime.parse(
                                              '${postData?[index]['post-date']}',
                                            ),
                                            locale:
                                                Localizations.localeOf(context)
                                                    .languageCode,
                                          ),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // حفظ المنشور
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.bookmark,
                                      color: Colors.grey,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: size.height * 0.01),

                              // محتوى المنشورات
                              if (postData?[index]['post-content'] != '')
                                ExpandableText(
                                  text: postData?[index]['post-content'],
                                  textColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),

                              // صور المنشورات
                              if (postData?[index]['post-media'] != '')
                                FutureBuilder(
                                  future: precacheImage(
                                    NetworkImage(
                                      '${postData?[index]['post-media']}',
                                    ),
                                    context,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: Text(
                                          S.of(context).loadingImage,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Center(
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      expandImage(
                                                    context,
                                                    postData,
                                                    image:
                                                        '${postData?[index]['post-media']}',
                                                    username: userData?[index]
                                                        ['user-name'],
                                                    userPhoto: userData?[index]
                                                        ['photoURL'],
                                                    imageDate: timeago.format(
                                                      DateTime.parse(
                                                          postData?[index]
                                                              ['post-date']),
                                                      locale: Localizations
                                                              .localeOf(context)
                                                          .languageCode,
                                                    ),
                                                    imageTextContent:
                                                        postData?[index]
                                                            ['post-content'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Image(
                                              image: NetworkImage(
                                                '${postData?[index]['post-media']}',
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                          S.of(context).errorLoadingImage,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),

                              // أيقونات التفاعل مع المنشورات
                              Row(
                                children: [
                                  // الإعجابات
                                  Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('likes-on-posts')
                                          .where(
                                            'post-id',
                                            isEqualTo: postData?[index]
                                                ['post-id'],
                                          )
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return customCircularProgressIndicator(
                                              context);
                                        }
                                        return TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LikesScreen(
                                                  userData: userData,
                                                  postData: postData?[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Center(
                                            child: Text(
                                              '${snapshot.data?.docs.length} ${S.of(context).likes}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // التعليقات
                                  Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('comments-on-posts')
                                          .where(
                                            'post-id',
                                            isEqualTo: postData?[index]
                                                ['post-id'],
                                          )
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return customCircularProgressIndicator(
                                            context,
                                          );
                                        }
                                        return TextButton(
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentsScreen(
                                                postData: postData?[index],
                                                index: index,
                                                userData: userData,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${snapshot.data?.docs.length} ${S.of(context).comments}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // المشاركات
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SharesScreen(),
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          '0 ${S.of(context).shares}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // الخط الفاصل بين الأيقونات
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  color: Theme.of(context).colorScheme.outline,
                                  width: double.infinity,
                                  height: 1,
                                ),
                              ),

                              // التعليق والإعجاب والمشاركة
                              Row(
                                children: [
                                  // الإعجاب
                                  Expanded(
                                    child: likePost(postData, index, size),
                                  ),

                                  // التعليق
                                  Expanded(
                                    child: commentPost(
                                      context,
                                      postData,
                                      index,
                                      size,
                                    ),
                                  ),

                                  // المشاركة
                                  Expanded(
                                    child: sharePost(context, size),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> likePost(
    List<QueryDocumentSnapshot<Object?>>? postData,
    int index,
    Size size, {
    context,
  }) =>
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('likes-on-posts')
            .where(
              'post-id',
              isEqualTo: postData?[index]['post-id'],
            )
            .snapshots(),
        builder: (context, snapshot) {
          return IconButton(
            onPressed: () {
              final controller = Get.put(LikesOnPostsController());

              // إذا كان فيه لايك على البوست؛ لما أضغط عليه يعمل إزالة للايك
              if (postData?[index]['like'] == true) {
                controller.disLikePost(
                  postId: postData?[index]['post-id'],
                  likeId: snapshot.data?.docs[0]['like-id'],
                );
              } else {
                // هنا لو مفيش لايك على البوست؛ لما اضيف اللايك ينفذه
                controller.likePost(
                  postId: postData?[index]['post-id'],
                );
              }
            },
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                postData?[index]['like'] == true
                    ? const Icon(
                        Icons.favorite,
                        size: 15,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        size: 15,
                        color: Colors.grey,
                      ),

                SizedBox(height: size.height * 0.001),

                // الإعجاب & إلغاء الإعجاب
                postData?[index]['like'] == true
                    ? Text(
                        S.of(context).disLike,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      )
                    : Text(
                        S.of(context).like,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
              ],
            ),
          );
        },
      );

  IconButton commentPost(
    BuildContext context,
    List<QueryDocumentSnapshot<Object?>>? postData,
    int index,
    Size size,
  ) =>
      IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentsScreen(
              postData: postData?[index],
              index: index,
              userData: userData,
            ),
          ),
        ),
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.comment,
              size: 15,
              color: Colors.grey,
            ),
            SizedBox(height: size.height * 0.001),
            Text(
              S.of(context).comment,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

  IconButton sharePost(BuildContext context, Size size) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          isDismissible: true,
          showDragHandle: true,
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                // مشاركة
                Text(
                  S.of(context).shareNow,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // بيانات المستخدم
                Row(
                  children: [
                    userData['photoURL'] == ''
                        // إذا كانت الصورة فارغة يتم إظهار أيقونة مكان الصورة
                        ? const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 30),
                          )
                        // إذا كان الصورة موجودة فيتم إظهارها
                        : CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              userData['photoURL'],
                            ),
                          ),

                    SizedBox(width: size.width * 0.05),

                    // اسم المستخدم
                    Flexible(
                      child: Text(
                        '${userData['name']} ${userData['last-name']}',
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          height: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(width: size.width * 0.01),

                    // بختبر هنا إذا كان الحساب مُوثّق ولا لا

                    if (userData['account-verified'] == true)
                      Icon(
                        Icons.verified,
                        color: Colors.green[700],
                        size: 13,
                      ),
                  ],
                ),

                SizedBox(height: size.height * 0.02),

                // كتابة نص فوق المنشور
                customTextFormField(
                  context: context,
                  controller: sharePostController,
                  keyboardType: TextInputType.multiline,
                  hintText:
                      '${S.of(context).yourMind}${S.of(context).question}',
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                ),

                SizedBox(height: size.height * 0.02),

                // شارك الآن
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SizedBox(
                    width: size.width * 0.35,
                    child: customElevatedButton(
                      context: context,
                      onPressed: () {},
                      text: S.of(context).shareNow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.share,
            size: 15,
            color: Colors.grey,
          ),
          SizedBox(height: size.height * 0.001),
          Text(
            S.of(context).shareNow,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

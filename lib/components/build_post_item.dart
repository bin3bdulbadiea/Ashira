import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/components/elevated_button.dart';
import 'package:ashira/components/expandImage.dart';
import 'package:ashira/components/expandable_text.dart';
import 'package:ashira/components/likes_comments_shares/comments_screen.dart';
import 'package:ashira/components/likes_comments_shares/likes_screen.dart';
import 'package:ashira/components/likes_comments_shares/shares_screen.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/controllers/likes_on_posts_controller.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/controllers/home_layout_controller.dart';
import 'package:ashira/controllers/post_controller.dart';
import 'package:ashira/layouts/post_screen/modify_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

Column buildPostItem(
  BuildContext context,
  int index,
  Size size, {
  required postData,
  required userData,
}) =>
    Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // استدعاء حساب المستخدم
                InkWell(
                  onTap: () {
                    // الانتقال إلى حساب مستخدم سواء كان الملف الشخصي أو ملف مستخدم آخر
                    // وهذا الانتقال يتم عن طريق الضغط على الصورة
                    if (userData?['id'] ==
                        FirebaseAuth.instance.currentUser?.uid) {
                      Get.put(HomeLayoutController()).changeBottomNavBar(4);
                    }
                  },
                  child: Row(
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
                                '${userData?['photoURL']}',
                              ),
                            ),

                      SizedBox(width: size.width * 0.05),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${userData?['full-name']}',
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
                                if (userData?['account-verified'] == true)
                                  Icon(
                                    Icons.verified,
                                    color: Colors.green[700],
                                    size: 13,
                                  ),
                              ],
                            ),

                            // لعرض توقيت مشاركة المنشور
                            Text(
                              timeago.format(
                                DateTime.parse(
                                  '${postData?[index]['post-date']}',
                                ),
                                locale: Localizations.localeOf(context)
                                    .languageCode,
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // إعدادت كل منشور > حفظ & تعديل & حذف
                      IconButton(
                        onPressed: () {
                          postSettings(context, postData, index);
                        },
                        icon: const Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                // محتوى المنشورات
                if (postData?[index]['post-content'] != '')
                  ExpandableText(
                    text: postData?[index]['post-content'],
                    textColor: Theme.of(context).colorScheme.onPrimary,
                  ),

                // صور المنشورات
                if (postData?[index]['post-media'] != '')
                  FutureBuilder(
                    future: precacheImage(
                      NetworkImage(postData?[index]['post-media']),
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
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return Center(
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => expandImage(
                                      context,
                                      postData,
                                      image:
                                          '${postData?[index]['post-media']}',
                                      username: '${userData?['full-name']}',
                                      userPhoto: '${userData?['photoURL']}',
                                      imageDate: timeago.format(
                                        DateTime.parse(
                                            postData?[index]['post-date']),
                                        locale: Localizations.localeOf(context)
                                            .languageCode,
                                      ),
                                      imageTextContent: postData?[index]
                                          ['post-content'],
                                    ),
                                  ),
                                );
                              },
                              child: Image(
                                image: NetworkImage(
                                  postData?[index]['post-media'],
                                ),
                              ),
                            ),
                          ),
                        );
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
                              isEqualTo: postData?[index]['post-id'],
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return customCircularProgressIndicator(context);
                          }
                          return TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LikesScreen(
                                    postData: postData?[index],
                                    userData: userData,
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
                              isEqualTo: postData?[index]['post-id'],
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return customCircularProgressIndicator(context);
                          }
                          return TextButton(
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
                              builder: (context) => const SharesScreen(),
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                      child: likeOnPost(
                        postData,
                        index,
                        size,
                        context: context,
                      ),
                    ),

                    // التعليق
                    Expanded(
                      child: IconButton(
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
                      ),
                    ),

                    // المشاركة
                    Expanded(
                      child: sharePost(context, size, postData, userData),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );

var sharePostController = TextEditingController();

Future<dynamic> postSettings(
  BuildContext context,
  postData,
  int index,
) =>
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.23,
        child: Column(
          children: [
            // حفظ
            ListTile(
              onTap: () {},
              leading: const Icon(
                Icons.bookmark,
                color: Colors.grey,
              ),
              title: Text(S.of(context).save),
            ),

            // تعديل
            ListTile(
              onTap: () {
                Get.put(PostController()).postController.text =
                    postData?[index]['post-content'];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifyPost(
                      postData: postData,
                      index: index,
                    ),
                  ),
                );
              },
              leading: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              title: Text(S.of(context).modify),
            ),

            // حذف
            deletePost(context, postData, index),
          ],
        ),
      ),
    );

IconButton sharePost(
  BuildContext context,
  Size size,
  postData,
  userData,
) =>
    IconButton(
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
                              '${userData?['photoURL']}',
                            ),
                          ),

                    SizedBox(width: size.width * 0.05),

                    // اسم المستخدم
                    Flexible(
                      child: Text(
                        userData?['full-name'],
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
                    if (userData?['account-verified'] == true)
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

StreamBuilder<QuerySnapshot> likeOnPost(
  postData,
  int index,
  Size size, {
  required context,
}) =>
    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('likes-on-posts')
          .where('post-id', isEqualTo: postData?[index]['post-id'])
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
              // تغيير أيقونة الإعجاب
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

ListTile deletePost(
  BuildContext context,
  postData,
  int index,
) =>
    ListTile(
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(S.of(context).deletePost),
            content: Text(S.of(context).deletePostContent),
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
                  Get.put(PostController()).deletePost(
                    postId: postData?[index]['post-id'],
                  );
                },
                child: Text(S.of(context).delete),
              ),
            ],
          ),
        );
      },
      leading: const Icon(
        Icons.delete,
        color: Colors.grey,
      ),
      title: Text(S.of(context).delete),
    );

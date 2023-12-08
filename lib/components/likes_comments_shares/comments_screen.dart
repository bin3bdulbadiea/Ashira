import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/components/outlined_button.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/controllers/comments_on_posts_controller.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsScreen extends StatelessWidget {
  CommentsScreen({
    super.key,
    required this.postData,
    required this.index,
    required this.userData,
  });

  final dynamic postData;

  final dynamic userData;

  final int index;

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).comments),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments-on-posts')
                    .where('post-id', isEqualTo: postData?['post-id'])
                    // .orderBy('comment-date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return customCircularProgressIndicator(context);
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text(S.of(context).noComments));
                  }

                  var data = snapshot.data?.docs;

                  return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              // صوة المستخدم
                              userData?['photoURL'] == ''
                                  ? CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      child: const Icon(
                                        Icons.person,
                                        size: 30,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                        '${userData?['photoURL']}',
                                      ),
                                    ),

                              // أيقونة الإعجاب بتعليق & عدد الإعجابات
                              likeIconAndLikesNumber(index, size),
                            ],
                          ),

                          SizedBox(width: size.width * 0.02),

                          // تصميم واجهة مستخدم للتعليقات
                          Expanded(
                            child: Column(
                              children: [
                                // محتوى التعليق
                                commentContent(context, data, index, size),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // كتابة تعليق
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  // صندوق كتابة التعليق
                  Expanded(
                    child: customTextFormField(
                      context: context,
                      controller: commentController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 2,
                      autofocus: true,
                      hintText: S.of(context).writeComment,
                    ),
                  ),

                  SizedBox(width: size.width * 0.02),

                  // أيقونة الإرسال
                  IconButton(
                    onPressed: () {
                      var controller = Get.put(CommentsOnPostsController());
                      controller.commentPost(
                        postId: postData?['post-id'],
                        commentContent: commentController.text,
                      );
                      commentController.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row likeIconAndLikesNumber(int index, Size size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // أيقونة الإعجاب بتعليق
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('comments-on-posts')
              .where('post-id', isEqualTo: postData?['post-id'])
              // .orderBy('comment-date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            var data = snapshot.data?.docs;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('likes-on-comments')
                  .where('comment-id', isEqualTo: data?[index]['comment-id'])
                  // .orderBy('like-date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return customCircularProgressIndicator(context);
                }

                return IconButton(
                  onPressed: () {
                    var controller = Get.put(CommentsOnPostsController());

                    // إذا كان فيه لايك على البوست؛ لما أضغط عليه يعمل إزالة للايك
                    if (data?[index]['like'] == true) {
                      controller.makeDisLikeOnComment(
                        postId: postData?['post-id'],
                        commentId: data?[index]['comment-id'],
                        likeId: snapshot.data?.docs[0]['like-id'],
                      );
                    } else {
                      // هنا لو مفيش لايك على البوست؛ لما اضيف اللايك ينفذه
                      controller.makeLikeOnComment(
                        commentId: data?[index]['comment-id'],
                        postId: postData?['post-id'],
                      );
                    }
                  },
                  icon: Row(
                    children: [
                      Icon(
                        data?[index]['like'] == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red.shade700,
                      ),

                      SizedBox(width: size.width * 0.003),

                      // عدد الإعجابات بتعليق
                      Text(
                        '${snapshot.data?.docs.length}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Container commentContent(
    BuildContext context,
    List<QueryDocumentSnapshot<Object?>>? commentData,
    int index,
    Size size,
  ) =>
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(50),
            bottomStart: Radius.circular(50),
            topEnd: Radius.circular(50),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(
          20, // start
          5, // top
          20, // end
          20, // bottom
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اسم المستخدم & أيقونة التوثيق & الإعدادات
            userDataAndSettings(
              commentData,
              index,
              size,
              context,
              userData: userData,
            ),

            SizedBox(height: size.height * 0.01),

            // محتوى التعليق
            Text(
              commentData?[index]['comment-content'],
            ),
          ],
        ),
      );

  Row userDataAndSettings(
    List<QueryDocumentSnapshot<Object?>>? commentData,
    int index,
    Size size,
    BuildContext context, {
    required userData,
  }) =>
      Row(
        children: [
          // اسم المستخدم
          TextButton(
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(
                EdgeInsets.zero,
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),

            // الانتقال إلى صفحة المستخدم
            onPressed: () {},

            // اسم المستخدم & توثيق الحساب & توقيت نشر التعليق
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المستخدم & توثيق الحساب
                Row(
                  children: [
                    // اسم المستخدم
                    Text(
                      '${userData?['full-name']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(width: size.width * 0.02),

                    // أيقونة التوثيق
                    if (userData?['account-verified'] == true)
                      Icon(
                        Icons.verified,
                        color: Colors.green[700],
                        size: 13,
                      ),
                  ],
                ),

                // توقيت نشر التعليق
                Text(
                  timeago.format(
                    commentData?[index]['comment-date'].toDate(),
                    locale: Localizations.localeOf(context).languageCode,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // بقوله هنا إذا كان اليوزر آي دي للمستخدم في الداتا بيز هو نفسه بتاع المستخدم يتم إظهار أيقونة الإعدادات
          // وده علشان ميكونش الإعدادات دي متاحة لكل الناس وإنما فقط لصاحب التعليق
          if (commentData?[index]['user-id'] ==
              FirebaseAuth.instance.currentUser?.uid)
            IconButton(
              onPressed: () => showModalBottomSheet(
                showDragHandle: true,
                isDismissible: true,
                context: context,
                builder: (context) => SizedBox(
                  height: size.height * 0.07,
                  child: Column(
                    children: [
                      // حذف
                      ListTile(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(S.of(context).deleteComment),
                            content: Text(S.of(context).confirmDeleteComment),
                            actions: [
                              // حذف
                              customOutlinedButton(
                                context,
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  var controller = Get.put(
                                    CommentsOnPostsController(),
                                  );

                                  controller.deleteCommentPost(
                                    postId: postData?['post-id'],
                                    commentId: commentData?[index]
                                        ['comment-id'],
                                  );
                                },
                                text: S.of(context).delete,
                              ),

                              // إلغاء
                              customOutlinedButton(
                                context,
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                text: S.of(context).cancel,
                              ),
                            ],
                          ),
                        ),
                        leading: const Icon(Icons.delete, color: Colors.grey),
                        title: Text(S.of(context).delete),
                      ),
                    ],
                  ),
                ),
              ),
              icon: const Icon(Icons.more_horiz),
            ),
        ],
      );
}

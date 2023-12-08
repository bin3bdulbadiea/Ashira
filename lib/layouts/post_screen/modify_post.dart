import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/components/neglecting_edit.dart';
import 'package:ashira/components/outlined_button.dart';
import 'package:ashira/components/show_toast.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/components/check_internet/check_internet.dart';
import 'package:ashira/controllers/post_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifyPost extends StatelessWidget {
  ModifyPost({super.key, required this.postData, required this.index});

  final dynamic postData;

  final int index;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GetBuilder(
      init: PostController(),
      builder: (controller) {
        return FutureBuilder(
          future: Connectivity().checkConnectivity(),
          builder: (context, snapshot) {
            if (snapshot.data == ConnectivityResult.none) {
              return CheckInternet(
                controllerPressed: () => Get.put(PostController()).update(),
              );
            }
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: StreamBuilder<QuerySnapshot>(
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

                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    appBar: AppBar(
                      title: Text(S.of(context).modifyPost),
                      actions: [
                        IconButton(
                          onPressed: () {
                            if (controller.postController.text != '' ||
                                controller.selectedPostMedia != null) {
                              controller.updatePost(
                                postId: postData?[index]['post-id'],
                                postContent: controller.postController.text,
                              );
                              Navigator.pop(context);
                              controller.selectedPostMedia == null;
                              Navigator.pop(context);
                            } else {
                              // لا يمكنك مشاركة منشور فارغ
                              showToast(
                                context: context,
                                message: S.of(context).emptyPost,
                              );
                            }
                          },
                          icon: const Icon(Icons.arrow_circle_up),
                          iconSize: 30,
                        ),
                      ],
                    ),
                    body: WillPopScope(
                      onWillPop: () async {
                        // إهمال التحرير
                        return await showDialog(
                              context: context,
                              builder: (context) => neglectingEdit(
                                context,
                                controller,
                              ),
                            ) ??
                            false;
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // حساب المستخدم
                                Row(
                                  children: [
                                    // الصورة الشخصية المستخدم
                                    data?[0]['photoURL'] == ''
                                        // في حالة اذا المستخدم مكنش عنده صورة شخصية
                                        ? const CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.grey,
                                            child: Icon(
                                              Icons.person,
                                              size: 30,
                                            ),
                                          )
                                        // في حالة اذا المستخدم عنده صورة شخصية
                                        : CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                              '${data?[0]['photoURL']}',
                                            ),
                                          ),

                                    SizedBox(width: size.width * 0.03),

                                    // الاسم
                                    Flexible(
                                      child: Text(
                                        '${data?[0]['name']} ${data?[0]['last-name']}',
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          height: 1.5,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // صندوق كتابة المنشور
                                TextFormField(
                                  controller: controller.postController,
                                  keyboardType: TextInputType.multiline,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        '${S.of(context).yourMind}${S.of(context).comma} ${data?[0]['name']}${S.of(context).question}',
                                  ),
                                  maxLines: 5,
                                  textInputAction: TextInputAction.newline,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),

                                SizedBox(height: size.height * 0.02),

                                // الصور
                                if (postData?[index]['post-media'] != '')
                                  Image.network(
                                    postData?[index]['post-media'],
                                    fit: BoxFit.fill,
                                  ),

                                if (postData?[index]['post-media'] == '')
                                  SizedBox(height: size.height * 0.02),

                                if (postData?[index]['post-media'] == '')
                                  // هنا يتم عرض الصورة اللي اخترناها من المعرض
                                  if (controller.selectedPostMedia != null)
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Image.file(
                                          controller.selectedPostMedia!,
                                          fit: BoxFit.fill,
                                        ),

                                        // حذف الصورة بعد اختيارها
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              controller.selectedPostMedia =
                                                  null;
                                              controller.update();
                                            },
                                            icon: const Icon(Icons.close),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ],
                                    ),

                                if (postData?[index]['post-media'] == '' &&
                                    controller.selectedPostMedia == null)
                                  SizedBox(height: size.height * 0.02),

                                if (postData?[index]['post-media'] == '' &&
                                    controller.selectedPostMedia == null)
                                  const Divider(),

                                if (postData?[index]['post-media'] == '' &&
                                    controller.selectedPostMedia == null)
                                  // إضافة صورة
                                  Row(
                                    children: [
                                      Expanded(
                                        child: customOutlinedButton(
                                          context,
                                          onPressed: () {
                                            controller.uploadPostMedia();
                                          },
                                          text: S.of(context).addImage,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

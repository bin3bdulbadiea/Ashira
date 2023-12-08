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

class PostScreen extends StatelessWidget {
  PostScreen({Key? key}) : super(key: key);

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
            // اختبار وجود الإنترنت من عدمه
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
                      // إضافة منشور
                      title: Text(S.of(context).newPost),
                      actions: [
                        // أيقونة مشاركة المنشور
                        addPost(controller, context, data),
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
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // حساب المستخدم
                                userAccount(data, size),

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
                                  maxLines: 10,
                                  textInputAction: TextInputAction.newline,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),

                                SizedBox(height: size.height * 0.02),

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
                                            controller.selectedPostMedia = null;
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

                                if (controller.selectedPostMedia == null)
                                  SizedBox(height: size.height * 0.02),

                                if (controller.selectedPostMedia == null)
                                  const Divider(),

                                if (controller.selectedPostMedia == null)
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

  Row userAccount(List<QueryDocumentSnapshot<Object?>>? data, Size size) {
    return Row(
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
            '${data?[0]['full-name']}',
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
    );
  }

  IconButton addPost(
    PostController controller,
    BuildContext context,
    List<QueryDocumentSnapshot<Object?>>? data,
  ) =>
      IconButton(
        onPressed: () {
          // بسأل إذا كان المنشور أو الصورة مش فاضيين علشان مينشرش منشور فاضي
          if (controller.postController.text != '' ||
              controller.selectedPostMedia != null) {
            // بسأله إذا كان الصورة مش فاضية، وده علشان ينشر منشور فيه صورة
            if (controller.selectedPostMedia != null) {
              controller.createPostWithMedia(
                context,
                postContent: controller.postController.text,
                postDateTime: '${DateTime.now()}',
              );

              // جارٍ مشاركة المنشور
              showToast(
                context: context,
                message: S.of(context).loadingPost,
              );
            } else {
              // بقوله طالما مفيش صورة يبقا انشر منشور نصي عادي
              controller.createPost(
                context,
                postContent: controller.postController.text,
                postDateTime: '${DateTime.now()}',
              );

              // جارٍ مشاركة المنشور
              showToast(
                context: context,
                message: S.of(context).loadingPost,
              );
            }

            // بقوله يتراجع للخلف علشان يطلع من صفحة إضافة منشور
            Navigator.pop(context);

            controller.selectedPostMedia == null;

            // تمت إضافة المنشور
            showToast(
              context: context,
              message: S.of(context).sharePost,
            );
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
      );
}

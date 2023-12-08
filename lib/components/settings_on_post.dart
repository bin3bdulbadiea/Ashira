import 'package:ashira/controllers/post_controller.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/layouts/post_screen/modify_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget settingsOnPosts(
  BuildContext context, {
  required postData,
  required int index,
}) =>
    IconButton(
      onPressed: () {
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
      },
      icon: const Icon(Icons.more_horiz),
    );

ListTile deletePost(
  BuildContext context,
  postData,
  int index,
) {
  return ListTile(
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
}

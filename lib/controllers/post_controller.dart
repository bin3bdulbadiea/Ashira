// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  bool isLoading = false;

  final postController = TextEditingController();

  // رفع صورة للمنشور
  Future<void> uploadPostMedia() async {
    final pickedFileList =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFileList != null) {
      selectedPostMedia = File(pickedFileList.path);
    }
    update();
  }

  File? selectedPostMedia;

  // العملية دي لو عاوز يعمل منشور مع صورة
  Future<void> createPostWithMedia(
    BuildContext context, {
    required String postContent,
    required String postDateTime,
  }) async {
    String postMediaUrl = '';

    isLoading = true;
    update();

    Reference postMediaRef = FirebaseStorage.instance.ref().child(
          'users/${FirebaseAuth.instance.currentUser?.uid}/posts/${Uri.file(selectedPostMedia!.path).pathSegments.last}',
        );
    await postMediaRef.putFile(selectedPostMedia!);
    postMediaUrl = await postMediaRef.getDownloadURL();

    // بيانات المنشور
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('posts').doc();

    docRef.set({
      'like': false,
      'post-id': docRef.id,
      'user-id': FirebaseAuth.instance.currentUser?.uid,
      'post-media': postMediaUrl,
      'post-content': postContent,
      'post-date': postDateTime,
    });

    isLoading = false;
    update();
  }

  // العملية دي لو عاوز يعمل منشور بدون صورة
  Future<void> createPost(
    BuildContext context, {
    required String postContent,
    required String postDateTime,
  }) async {
    isLoading = true;
    update();

    // بيانات المنشور
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('posts').doc();

    docRef.set({
      'like': false,
      'post-id': docRef.id,
      'user-id': FirebaseAuth.instance.currentUser?.uid,
      'post-media': '',
      'post-content': postContent,
      'post-date': postDateTime,
    });

    isLoading = false;
    update();
  }

  // تعديل المنشور
  void updatePost({
    required String postId,
    required String postContent,
  }) async {
    if (selectedPostMedia == null) {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'post-content': postContent,
      });
    } else {
      String postMediaUrl = '';

      Reference postMediaRef = FirebaseStorage.instance.ref().child(
            'users/${FirebaseAuth.instance.currentUser?.uid}/posts/${Uri.file(selectedPostMedia!.path).pathSegments.last}',
          );
      await postMediaRef.putFile(selectedPostMedia!);
      postMediaUrl = await postMediaRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'post-content': postContent,
        'post-media': postMediaUrl,
      });
    }
    postController.clear();
    selectedPostMedia == null;
  }

  // حذف المنشور
  void deletePost({
    required String postId,
    // required String commentOnPostId,
    // required String likeOnCommentId,
    // required String likeOnPostId,
  }) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();

    // await FirebaseFirestore.instance
    //     .collection('likes-on-posts')
    //     .doc(likeOnPostId)
    //     .delete();

    // await FirebaseFirestore.instance
    //     .collection('comments-on-posts')
    //     .doc(commentOnPostId)
    //     .delete();

    // await FirebaseFirestore.instance
    //     .collection('likes-on-comments')
    //     .doc(likeOnCommentId)
    //     .delete();
  }
}

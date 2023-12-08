import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CommentsOnPostsController extends GetxController {
  // التعليقات على كل منشور
  void commentPost({
    required String postId,
    required String commentContent,
  }) async {
    DocumentReference commentRef =
        FirebaseFirestore.instance.collection('comments-on-posts').doc();

    await commentRef.set(
      {
        'user-id': FirebaseAuth.instance.currentUser?.uid,
        'post-id': postId,
        'comment-id': commentRef.id,
        'comment-content': commentContent,
        'comment-date': DateTime.now(),
        'like': false,
      },
    );
  }

  // حذف التعليقات على كل منشور
  void deleteCommentPost({
    required String postId,
    required String commentId,
  }) async {
    FirebaseFirestore.instance
        .collection('comments-on-posts')
        .doc(commentId)
        .delete();
  }

  // إضافة إعجاب على كل تعليق
  void makeLikeOnComment({
    required String postId,
    required String commentId,
  }) async {
    FirebaseFirestore.instance
        .collection('comments-on-posts')
        .doc(commentId)
        .update({'like': true});

    DocumentReference likeRef =
        FirebaseFirestore.instance.collection('likes-on-comments').doc();

    likeRef.set({
      'like-id': likeRef.id,
      'user-id': FirebaseAuth.instance.currentUser?.uid,
      'comment-id': commentId,
      'post-id': postId,
      'like-date': DateTime.now(),
    });
  }

  // حذف إعجاب على كل تعليق
  void makeDisLikeOnComment({
    required String postId,
    required String commentId,
    required String likeId,
  }) async {
    FirebaseFirestore.instance
        .collection('comments-on-posts')
        .doc(commentId)
        .update({'like': false});

    FirebaseFirestore.instance
        .collection('likes-on-comments')
        .doc(likeId)
        .delete();
  }
}

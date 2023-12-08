import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LikesOnPostsController extends GetxController {
  // الإعجابات على كل منشور
  void likePost({
    required String postId,
  }) async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({'like': true});

    DocumentReference likeRef =
        FirebaseFirestore.instance.collection('likes-on-posts').doc();

    likeRef.set({
      'like-id': likeRef.id,
      'user-id': FirebaseAuth.instance.currentUser?.uid,
      'post-id': postId,
      'like-date': DateTime.now(),
    });
  }

  // إزالة الإعجابات على كل منشور
  void disLikePost({
    required String postId,
    required String likeId,
  }) async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({'like': false});

    FirebaseFirestore.instance
        .collection('likes-on-posts')
        .doc(likeId)
        .delete();
  }
}

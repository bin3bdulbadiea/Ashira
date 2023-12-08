import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsController extends GetxController {
  bool requestDone = false;

  @override
  void onInit() {
    super.onInit();
    _loadRequestDone();
  }

  // إضافة صديق
  void addFriend({
    required String senderId,
    required String reciverId,
  }) async {
    requestDone = false;
    update();

    DocumentReference friendsRef =
        FirebaseFirestore.instance.collection('friends-requests').doc();

    friendsRef.set({
      'doc-id': friendsRef.id,
      'request-from-id': senderId,
      'request-date': DateTime.now(),
      'request-to-id': reciverId,
    });

    requestDone = true;
    update();

    _saveRequestDone();
  }

  // قيد الانتظار
  void disAddFriend({
    required String docId,
  }) async {
    requestDone = true;
    update();

    DocumentReference friendsRef =
        FirebaseFirestore.instance.collection('friends-requests').doc(docId);

    friendsRef.delete();

    requestDone = false;
    update();

    _saveRequestDone();
  }

  void _saveRequestDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('requestDone', requestDone);
  }

  void _loadRequestDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    requestDone = prefs.getBool('requestDone') ?? false;
    update();
  }
}

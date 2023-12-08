import 'package:ashira/components/build_post_item.dart';
import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('user-id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          // .orderBy('post-date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return customCircularProgressIndicator(context);
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text(S.of(context).noPosts));
        }

        var postData = snapshot.data?.docs;
        return StreamBuilder<QuerySnapshot>(
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
            var userData = snapshot.data?.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    itemCount: postData?.length,
                    itemBuilder: (context, index) => buildPostItem(
                      context,
                      index,
                      size,
                      postData: postData,
                      userData: userData?[0],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

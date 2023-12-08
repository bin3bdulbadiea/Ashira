import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({
    super.key,
    required this.userData,
    required this.postData,
  });

  final dynamic userData;

  final dynamic postData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).likes),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('likes-on-posts')
            .where('post-id', isEqualTo: postData?['post-id'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return customCircularProgressIndicator(context);
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text(S.of(context).noLikes));
          }
          var data = snapshot.data?.docs;
          return ListView.builder(
            itemCount: data?.length,
            itemBuilder: (context, index) => ListTile(
              // onTap: () {
              //   // لازم اعمل صفحة خاصة بالبروفايل بحيث عندما يتم الضغط عليها يتم فتح حساب المستخدم اللي عامل لايك
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ProfileScreen(data: data?[index]),
              //     ),
              //   );
              // },
              leading: userData?['photoURL'] == ''
                  ? const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      child: Icon(
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
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${userData?['full-name']}'),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),

                  // بختبر هنا إذا كان الحساب مُوثّق ولا لا

                  if (userData?['account-verified'] == true)
                    Icon(
                      Icons.verified,
                      color: Colors.green[700],
                      size: 13,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

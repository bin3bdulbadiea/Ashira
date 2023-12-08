import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/components/profile_screen/profile.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final searchController = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customTextFormField(
          context: context,
          controller: searchController,
          keyboardType: TextInputType.text,
          hintText: S.of(context).search,
          autofocus: true,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('full-name', isGreaterThanOrEqualTo: searchController.text)
            .where('full-name', isLessThan: '${searchController.text}\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return customCircularProgressIndicator(context);
          }

          var userData = snapshot.data?.docs;

          if (searchController.text != '') {
            return ListView.builder(
              itemCount: userData?.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  // لما اعمل صفحة البروفايل
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userData: userData?[index],
                      ),
                    ),
                  );
                },
                leading: userData?[index]['photoURL'] == ''
                    ? const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20,
                        child: Icon(Icons.person, size: 30),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(
                          '${userData?[index]['photoURL']}',
                        ),
                        backgroundColor: Colors.grey,
                        radius: 20,
                      ),
                title: Text(
                  '${userData?[index]['full-name']}',
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

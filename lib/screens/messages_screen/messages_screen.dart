import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/screens/messages_screen/chat.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({super.key});

  final search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onVerticalDragDown: (details) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          // البحث
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: customTextFormField(
              context: context,
              controller: search,
              keyboardType: TextInputType.text,
              hintText: S.of(context).search,
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) {},
            ),
          ),

          // الرسائل
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (context, index) => Container(
                height: size.height * 0.001,
                color: Theme.of(context).colorScheme.outline,
              ),
              itemBuilder: (context, index) => ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                ),
                leading: const CircleAvatar(
                  radius: 25,
                  foregroundImage: AssetImage('assets/images/logo.png'),
                ),
                title: const Text(
                  'أحمد عبد البديع',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

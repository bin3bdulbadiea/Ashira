import 'package:ashira/components/text_form_field.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back),
                    CircleAvatar(
                      radius: 15,
                      foregroundImage: AssetImage('assets/images/logo.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              const Text('أحمد عبد البديع'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => showModalBottomSheet(
                showDragHandle: true,
                isDismissible: true,
                context: context,
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        leading: const Icon(Icons.delete),
                        title: const Text('حذف'),
                      ),
                    ],
                  ),
                ),
              ),
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            // محتوى الرسائل
            const Expanded(
              child: Text('محتوى الرسائل'),
            ),

            // صندوق المراسلة
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  // صندوق كتابة التعليق
                  Expanded(
                    child: customTextFormField(
                      context: context,
                      controller: chatController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 2,
                      autofocus: true,
                      hintText: 'مراسلة',
                    ),
                  ),

                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                  // أيقونة الإرسال
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

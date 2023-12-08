import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {},
              child: const Text('تمييز الكل مقروء'),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (context, index) => Container(
              height: size.height * 0.001,
              color: Theme.of(context).colorScheme.outline,
            ),
            itemBuilder: (context, index) => ListTile(
              onTap: () {},
              leading: const CircleAvatar(
                radius: 30,
                foregroundImage: AssetImage('assets/images/logo.png'),
              ),
              title: const Text(
                'قام أحمد عبد البديع بالإعجاب بمنشورك.',
                style: TextStyle(fontSize: 13),
              ),
              subtitle: const Text(
                'منذ دقيقة',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

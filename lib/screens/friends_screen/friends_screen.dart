import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قائمة الأصدقاء
            Row(
              children: [
                const Text(
                  'قائمة الأصدقاء',
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'عرض',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ),
              ],
            ),

            // خط فاصل
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                color: Colors.grey,
                height: size.height * 0.001,
              ),
            ),

            // طلبات الصداقة
            const Text(
              'طلبات الصداقة',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: size.height * 0.01),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 20,
              separatorBuilder: (context, index) => SizedBox(
                height: size.height * 0.009,
              ),
              itemBuilder: (context, index) => MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Row(
                  children: [
                    // صورة المستخدم
                    const CircleAvatar(
                      radius: 50,
                      foregroundImage: AssetImage('assets/images/logo.png'),
                    ),

                    SizedBox(width: size.width * 0.03),

                    // اسم المستخدم & قبول & رفض
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // اسم المستخدم
                          const Text(
                            'أحمد عبد البديع',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          SizedBox(height: size.height * 0.01),

                          // قبول & رفض
                          Row(
                            children: [
                              // قبول
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Colors.green.shade700,
                                    ),
                                    overlayColor:
                                        const MaterialStatePropertyAll(
                                      Colors.grey,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'قبول',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              SizedBox(width: size.width * 0.01),

                              // رفض
                              Expanded(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('رفض'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

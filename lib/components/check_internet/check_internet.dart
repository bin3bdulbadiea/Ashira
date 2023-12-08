import 'package:ashira/components/outlined_button.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:flutter/material.dart';

class CheckInternet extends StatelessWidget {
  const CheckInternet({super.key, required this.controllerPressed});

  final void Function() controllerPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الشعار
              const Text(
                'عشيرة',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Ruwudu',
                ),
              ),

              // صورة عدم وجود اتصال
              Image.asset('assets/images/no_signal.png', scale: 3),

              // لا يوجد اتصال بالشبكة
              Text(
                S.of(context).noNetwork,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // قم بالتحقّق من الاتصال بالشبكة، ثمّ قم بتحديث الصفحة.
              Text(
                S.of(context).checkNetwork,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // تحديث
              customOutlinedButton(
                context,
                onPressed: controllerPressed,
                text: S.of(context).update,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

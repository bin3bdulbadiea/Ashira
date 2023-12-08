// ignore_for_file: use_build_context_synchronously

import 'package:ashira/components/show_toast.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/layouts/home/home_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool visibilityPassword = true;

  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisibility() {
    visibilityPassword = !visibilityPassword;

    suffix = visibilityPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    update();
  }

  Future<void> forgetPassword({required BuildContext context}) async {
    isLoading = true;
    update();

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: emailController.text,
      )
          .then(
        (value) {
          showToast(
            context: context,
            message: S.of(context).changePasswordMessage,
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showToast(
          context: context,
          message: S.of(context).invalidEmail,
        );
      } else if (e.code == 'user-not-found') {
        showToast(
          context: context,
          message: S.of(context).userNotFound,
        );
      }
    }

    isLoading = false;
    update();
  }

  // Future<void> checkAccountStatus(BuildContext context) async {

  // }

  Future<void> userLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    update();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // DocumentSnapshot snapshot = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(FirebaseAuth.instance.currentUser?.uid)
      //     .get();
      // if (snapshot['account-disabled'] == true) {
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const ReactiveAccount(),
      //     ),
      //     (route) => false,
      //   );
      // } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeLayout(),
        ),
        (route) => false,
      );
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showToast(
          context: context,
          message: S.of(context).invalidEmail,
        );
      } else if (e.code == 'user-disabled') {
        showToast(
          context: context,
          message: S.of(context).userDisabled,
        );
      } else if (e.code == 'user-not-found') {
        showToast(
          context: context,
          message: S.of(context).userNotFound,
        );
      } else if (e.code == 'wrong-password') {
        showToast(
          context: context,
          message: S.of(context).wrongPassword,
        );
      }
    }

    isLoading = false;
    update();
  }
}

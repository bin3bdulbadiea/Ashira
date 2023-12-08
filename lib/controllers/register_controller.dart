// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:ashira/components/show_toast.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/layouts/home/home_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  bool isLoading = false;

  DateTime? selectedDate;

  String gender = '';

  var dateController = TextEditingController();

  bool visibilityPassword = true;

  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisibility() {
    visibilityPassword = !visibilityPassword;

    suffix = visibilityPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    update();
  }

  Future<void> userRegister({
    required BuildContext context,
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    update();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'id': FirebaseAuth.instance.currentUser!.uid,
        'name': name,
        'last-name': lastName,
        'nick-name': '',
        'full-name': '$name $lastName',
        'email': email,
        'birthdate': selectedDate,
        'gender': gender,
        'photoURL': '',
        'marital-status': '',
        'bio': '',
        'account-created': DateTime.now(),
        'account-verified': false,
        'account-disabled': false,
        'account-disable-date': null,
        'posts': [],
      });
      // Successful register
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      showToast(
        context: context,
        message: S.of(context).verifyEmailAddress,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeLayout(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(
          context: context,
          message: S.of(context).emailAlreadyInUse,
        );
      } else if (e.code == 'invalid-email') {
        showToast(context: context, message: S.of(context).invalidEmail);
      } else if (e.code == 'weak-password') {
        showToast(context: context, message: S.of(context).weakPassword);
      }
    }

    isLoading = false;
    update();
  }
}

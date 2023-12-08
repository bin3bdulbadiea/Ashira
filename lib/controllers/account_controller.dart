// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:ashira/components/show_toast.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  final nameController = TextEditingController();

  final lastNameController = TextEditingController();

  final nickNameController = TextEditingController();

  final bioController = TextEditingController();

  final passwordController = TextEditingController();

  final newPasswordController = TextEditingController();

  final confirmNewPasswordController = TextEditingController();

  String gender = '';

  String maritalStatus = '';

  var dateController = TextEditingController();

  DateTime? selectedDate;

  bool isLoading = false;

  // تعديل معلومات المستخدم
  Future<void> updateUserData({
    required String name,
    required String lastName,
    required String nickName,
    required String bio,
    required String gender,
    required String maritalStatus,
    required DateTime birthdate,
  }) async {
    isLoading = true;
    update();

    // Upload personal image if selected
    String personalImageUrl = '';

    // العملية دي لو عاوز يغير الصورة الشخصية فقط ومعاها بيانات المستخدم
    if (selectedPersonalImage != null) {
      Reference personalImageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(FirebaseAuth.instance.currentUser?.uid ?? '')
          .child('personal_image.jpg');
      await personalImageRef.putFile(selectedPersonalImage!);
      personalImageUrl = await personalImageRef.getDownloadURL();

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'photoURL': personalImageUrl,
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'name': name,
        'last-name': lastName,
        'nick-name': nickName,
        'full-name': '$name $lastName',
        'bio': bio,
        'gender': gender,
        'marital-status': maritalStatus,
        'birthdate': birthdate,
      });

      selectedPersonalImage = null;

      isLoading = false;
      update();
    } else {
      // العملية دي لو عاوز يغير بيانات المستخدم فقط
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'name': name,
        'last-name': lastName,
        'nick-name': nickName,
        'full-name': '$name $lastName',
        'bio': bio,
        'gender': gender,
        'marital-status': maritalStatus,
        'birthdate': birthdate,
      });
    }

    isLoading = false;
    update();
  }

  File? selectedPersonalImage;

  // تغيير الصورة الشخصية
  Future<void> selectPersonalImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedPersonalImage = File(pickedFile.path);
      update();
    }
  }

  // تغيير كلمة السر
  Future<void> changePassword(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading = true;
    update();

    try {
      // Reauthenticate the user with their current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: currentPassword,
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      // Change the user's password
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);

      showToast(context: context, message: S.of(context).changedPassword);
      Navigator.pop(context);
      passwordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        showToast(context: context, message: S.of(context).incorrectPassword);
      } else {
        showToast(context: context, message: S.of(context).errorChangePassword);
      }
    }

    isLoading = false;
    update();
  }

  bool visibilityPassword = true;

  IconData suffix = Icons.visibility_outlined;

  // تغيير أيقونة العين الخاصة بكلمة السر
  void changePasswordVisibility() {
    visibilityPassword = !visibilityPassword;

    suffix = visibilityPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    update();
  }

  bool confirmVisibilityPassword = true;

  IconData confirmSuffix = Icons.visibility_outlined;

  // تغيير أيقونة العين الخاصة بكلمة السر مرة أخرى
  void changeConfirmPasswordVisibility() {
    confirmVisibilityPassword = !confirmVisibilityPassword;

    confirmSuffix = confirmVisibilityPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    update();
  }
}

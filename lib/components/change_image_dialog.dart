// تغيير الصورة الشخصية / صورة الغلاف
import 'package:ashira/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<dynamic> changeImageDialog(
  BuildContext context,
  List<QueryDocumentSnapshot<Object?>>? data, {
  required String title,
  required Widget content,
  required void Function()? galleryOnPressed,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: galleryOnPressed,
            child: Text(
              S.of(context).change,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );

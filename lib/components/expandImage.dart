// ignore_for_file: file_names

import 'package:ashira/components/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

Scaffold expandImage(
  context,
  dynamic data, {
  required String image,
  required String username,
  required String userPhoto,
  String imageDate = '',
  String imageTextContent = '',
}) =>
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            PhotoView(
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 1.1,
              imageProvider: NetworkImage(image),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 15,
                            foregroundImage: NetworkImage(userPhoto),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      imageDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    ExpandableText(
                      text: imageTextContent,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

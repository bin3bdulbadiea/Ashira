import 'package:flutter/material.dart';

Center customCircularProgressIndicator(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Theme.of(context).colorScheme.onPrimary,
      ),
    ),
  );
}

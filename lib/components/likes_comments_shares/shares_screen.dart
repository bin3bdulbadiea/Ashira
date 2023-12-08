import 'package:ashira/generated/l10n.dart';
import 'package:flutter/material.dart';

class SharesScreen extends StatelessWidget {
  const SharesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).shares),
      ),
    );
  }
}

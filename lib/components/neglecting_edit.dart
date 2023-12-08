import 'package:ashira/components/outlined_button.dart';
import 'package:ashira/controllers/post_controller.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:flutter/material.dart';

AlertDialog neglectingEdit(
  BuildContext context,
  PostController controller,
) =>
    AlertDialog(
      title: Text(S.of(context).neglectingEditing),
      content: Text(
        S.of(context).ignoreEdit,
      ),
      actions: [
        customOutlinedButton(
          context,
          onPressed: () {
            Navigator.pop(context);
            controller.postController.clear();
            controller.selectedPostMedia == null;
            Navigator.pop(context);
          },
          text: S.of(context).neglecting,
        ),
        customOutlinedButton(
          context,
          onPressed: () => Navigator.pop(context),
          text: S.of(context).back,
        ),
      ],
    );

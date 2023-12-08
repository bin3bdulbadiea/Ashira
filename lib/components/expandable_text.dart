import 'package:ashira/generated/l10n.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  final Color textColor;

  const ExpandableText({
    super.key,
    required this.text,
    required this.textColor,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: widget.text,
      style: const TextStyle(fontSize: 16),
    );
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    final numberOfLines = textPainter.computeLineMetrics().length;
    final showButtons = numberOfLines > 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
            shape: const MaterialStatePropertyAll(RoundedRectangleBorder()),
            minimumSize: MaterialStatePropertyAll(
              Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.07,
              ),
            ),
            alignment: AlignmentDirectional.centerStart,
          ),
          onPressed: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Text(
            widget.text,
            maxLines: expanded ? 5 : 1000,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, color: widget.textColor),
          ),
        ),
        if (showButtons)
          InkWell(
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Text(
              expanded ? S.of(context).showMore : '',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

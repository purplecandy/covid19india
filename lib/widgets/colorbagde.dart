import 'package:flutter/material.dart';

class ColorBadge extends StatelessWidget {
  final String content;
  final Color backgroundColor;
  final Color textColor;
  const ColorBadge(
      {Key key, this.content, this.backgroundColor, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        content,
        style: TextStyle(
            color: textColor, fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }
}

import 'package:flutter/material.dart';


class AppTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLine;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool centerText;

  const AppTextWidget({
    Key? key,
    required this.text,
    this.style,
    this.maxLine = 1,
    this.fontSize = 17,
    this.textColor = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.centerText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // if text style already give use it otherwise use other parameters
      style: style ?? TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight),
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: maxLine,
      textAlign: centerText ? TextAlign.center : TextAlign.start,
    );
  }
}

import 'package:flutter/material.dart';

extension SizeExtension on BuildContext {
  Size get getSize => MediaQuery.of(this).size;

  double get getHeight => MediaQuery.sizeOf(this).height;

  double get getWidth => MediaQuery.sizeOf(this).width;

  EdgeInsetsGeometry get initialHorizontalPadding => EdgeInsets.symmetric(horizontal: getWidth * 0.02);
}

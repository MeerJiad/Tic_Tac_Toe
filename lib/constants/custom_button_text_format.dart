import 'package:flutter/material.dart';

class CustomButtonTextFormat {
  static Transform buttonTextFormat({
    required String text,
    required TextStyle textStyle,
  }) {
    return Transform.translate(
      offset: Offset(0, -3),
      child: Text(text, style: textStyle),
    );
  }
}

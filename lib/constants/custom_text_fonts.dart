import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFonts {
  static TextStyle coinyGoogleFonts({
    double fontSize = 32,
    Color color = Colors.white,
  }) {
    return GoogleFonts.coiny(
      fontSize: fontSize,
      letterSpacing: 3,
      color: color,
    );
  }
}

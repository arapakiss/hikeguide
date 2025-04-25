import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static final textTheme = TextTheme(
    displayLarge:  GoogleFonts.interTight(fontSize: 48, fontWeight: FontWeight.w700),
    headlineMedium:GoogleFonts.interTight(fontSize: 24, fontWeight: FontWeight.w600),
    bodyLarge:      GoogleFonts.interTight(fontSize: 16, fontWeight: FontWeight.w400),
    labelLarge:     GoogleFonts.interTight(fontSize: 14, fontWeight: FontWeight.w500),
  );
}

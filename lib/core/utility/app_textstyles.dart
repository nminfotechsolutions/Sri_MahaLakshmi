import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static googleFontIbmPlex({required String tittle,double fontSize = 25}) {
    return Text(
      tittle,
      style: GoogleFonts.ibmPlexSans(
        shadows: [
          Shadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(1, 1),
          ),
        ],
        letterSpacing: 2.5,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: AppColor.darkTeal,
      ),
    );
  }

  static googleFontLaTo({required String tittle,double fontSize = 25}) {
    return Text(
      tittle,
      style: GoogleFonts.lato(


        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: AppColor.darkTeal,
      ),
    );
  }

  static textWith600({
    required String text,
    double fontSize = 18,
    double hight = 1.5,
    Color? color = AppColor.lightBlack,
  }) {
    return Text(
      text,
      style: GoogleFonts.ibmPlexSans(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static textWithSmall({
    required String text,
    Color? color = AppColor.lightgray,
    FontWeight? fontWeight = FontWeight.w500,
    TextAlign? textAlign,
    double? fontSize = 16,
  }) {
    return Text(
      textAlign: textAlign,
      text,
      style: GoogleFonts.ibmPlexSans(
        fontSize: fontSize!,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_app/theme/app_colors.dart';

Widget customText({
  String title = "",
  double? fontSize = 14,
  FontWeight? fontWeight = FontWeight.w400,
  Color? color = AppColors.white,
  TextAlign? textAlign,
  int? maxLines,
  double? height,
  double? letterSpacing,
}) {
  return Text(
    title,
    textAlign: textAlign,
    maxLines: maxLines,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: "Poppins",
      height: height,
      letterSpacing: letterSpacing,
    ),
  );
}

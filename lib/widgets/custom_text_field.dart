import 'package:flutter/material.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/theme/app_colors.dart';

Widget customTextField({
  required TextEditingController controller,
  void Function(String)? onChanged,
}) {
  return TextFormField(
    expands: true,
    maxLines: null,
    style: TextStyle(color: AppColors.white, fontSize: 14),
    cursorColor: AppColors.red,
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: Strings.SEARCH_MOVIE,
      contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red, width: 0.8),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red, width: 0.8),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red, width: 0.8),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  );
}

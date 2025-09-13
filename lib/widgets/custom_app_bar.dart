import 'package:flutter/material.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:movie_app/widgets/custom_text.dart';

Widget customAppBar({String title = ""}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BackButton(color: AppColors.white),
        Expanded(
          child: customText(
            title: title,
            color: AppColors.white,
            fontSize: 25,
            maxLines: 3,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

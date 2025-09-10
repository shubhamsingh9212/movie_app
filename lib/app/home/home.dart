import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/home/home_controller.dart';
import 'package:movie_app/app/home/widgets.dart';
import 'package:movie_app/routes/app_pages.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:movie_app/widgets/custom_sizedbox.dart';
import 'package:movie_app/widgets/custom_text.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: customText(
                    title: "Watch Me!",
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.BOOKMARKED_MOVIES),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.bookmark, color: AppColors.red, size: 30),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.SEARCH_MOVIES),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.search, color: AppColors.red, size: 30),
                  ),
                ),
              ],
            ),
            customSizedBox(height: 20),
            MoviesTabBar(),
          ],
        ),
      ),
    );
  }
}

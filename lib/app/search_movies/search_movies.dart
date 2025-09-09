import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/home/home_controller.dart';
import 'package:movie_app/app/home/widgets.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:movie_app/widgets/custom_sizedbox.dart';
import 'package:movie_app/widgets/custom_text.dart';

class SearchMoviesView extends GetView<HomeController> {
  const SearchMoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    width: width * 0.5,
                    height: 45,
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      style: TextStyle(color: AppColors.white, fontSize: 14),
                      cursorColor: AppColors.red,
                      controller: controller.searchController,
                      onChanged: (value) {
                        controller.searchMovies();
                      },
                      decoration: InputDecoration(
                        hintText: Strings.SEARCH_MOVIE,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.red,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.red,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.red,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),
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

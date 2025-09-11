import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/home/home_controller.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:movie_app/widgets/custom_sizedbox.dart';
import 'package:movie_app/widgets/movie_poster.dart';

class MoviesTabBar extends GetView<HomeController> {
  const MoviesTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.white,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelColor: AppColors.unselectedColor,
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            controller: controller.tabController,
            indicator: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: List.generate(
              controller.tabController.length,
              (index) => Tab(text: controller.tabTitles[index]),
            ),
          ),
          customSizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                GetBuilder<HomeController>(
                  id: Strings.TRENDING_MOVIES,
                  builder: (context) {
                    return moviesGridView(
                      movieList: controller.trendingMovies?.results ?? [],
                      scrollController: controller.trendingScrollController,
                      isLoading: controller.istrendingMoviesLoading,
                    );
                  },
                ),
                GetBuilder<HomeController>(
                  id: Strings.NOW_PLAYING_MOVIES,
                  builder: (context) {
                    return moviesGridView(
                      movieList: controller.nowPlayingMovies?.results ?? [],
                      scrollController: controller.nowPlayingScrollController,
                      isLoading: controller.isNowPlayingMoviesLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

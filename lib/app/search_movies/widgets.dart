import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/home/home_controller.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:movie_app/widgets/custom_cached_network_image.dart';
import 'package:movie_app/widgets/custom_text.dart';

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
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                Obx(() {
                  return moviesGridView(
                    movieList: controller.filteredTrendingMovieList,
                  );
                }),
                Obx(() {
                  return moviesGridView(
                    movieList: controller.filteredNowPlayingMovieList,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget moviesGridView({required List<Result>? movieList}) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: StaggeredGrid.count(
        axisDirection: AxisDirection.down,
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: List.generate(movieList?.length ?? 0, (index) {
          return moviePoster(movie: movieList?[index] ?? Result());
        }),
      ),
    );
  }

  Widget moviePoster({required Result movie}) {
    return InkWell(
      onTap: () {
        controller.getTrendingMoviesList();
        // FocusManager.instance.primaryFocus?.unfocus();
        // Get.toNamed(Routes.MOVIE_DETAILS, arguments: {"movie_details": movie});
      },
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: customCachedNetworkImage(imgPath: movie.posterPath ?? ""),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: customText(
                title: movie.title ?? "",
                maxLines: 1,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: customText(
                title: movie.releaseDate.toString(),
                maxLines: 1,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

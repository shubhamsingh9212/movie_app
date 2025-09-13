import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/routes/app_pages.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:movie_app/widgets/custom_cached_network_image.dart';
import 'package:movie_app/widgets/custom_text.dart';
import 'package:movie_app/widgets/dotted_spinner.dart';
import 'package:shimmer/shimmer.dart';

Widget moviePoster({required Result movie, bool isBookmarked = false}) {
  return InkWell(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
      Get.toNamed(
        Routes.MOVIE_DETAILS,
        arguments: {"movie_details": movie, "is_bookmarked": isBookmarked},
      );
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

Widget moviesGridView({
  required List<Result>? movieList,
  ScrollController? scrollController,
  required RxBool isLoading,
  required RxBool isFetching,
  bool isBookmarked = false,
}) {
  return Obx(() {
    if (isFetching.value) {
      return shimmerGrid();
    }
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        children: [
          StaggeredGrid.count(
            axisDirection: AxisDirection.down,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: List.generate(movieList?.length ?? 0, (index) {
              return moviePoster(
                movie: movieList?[index] ?? Result(),
                isBookmarked: isBookmarked,
              );
            }),
          ),
          Obx(() => isLoading.value ? DottedSpinner() : const SizedBox()),
        ],
      ),
    );
  });
}

Widget shimmerMovieItem() {
  return Container(
    height: 300,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

Widget shimmerGrid() {
  return Padding(
    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
    child: StaggeredGrid.count(
      axisDirection: AxisDirection.down,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: List.generate(6, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade700,
          child: shimmerMovieItem(),
        );
      }),
    ),
  );
}

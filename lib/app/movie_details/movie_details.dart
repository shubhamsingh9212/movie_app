import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/movie_details/movie_details_controller.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:movie_app/widgets/custom_app_bar.dart';
import 'package:movie_app/widgets/custom_cached_network_image.dart';
import 'package:movie_app/widgets/custom_sizedbox.dart';
import 'package:movie_app/widgets/custom_text.dart';

class MovieDetailsView extends GetView<MovieDetailsController> {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final movie = controller.movieDetails;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: customAppBar(title: Strings.ABOUT_THE_MOVIE)),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () => controller.bookmarkMovie(),
                      child: Obx(
                        () => Icon(
                          controller.isBookmarked.value
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 35,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              customSizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: customCachedNetworkImage(
                        height: height * 0.6,
                        imgPath: movie.posterPath ?? "",
                      ),
                    ),
                    customSizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: customText(
                            title: movie.title ?? "",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            StarRating(
                              starCount: 5,
                              size: 24,
                              rating: (movie.voteAverage ?? 0) / 2,
                              color: AppColors.red,
                            ),
                            customSizedBox(height: 4),
                            customText(
                              title: "${(movie.voteAverage ?? 0)} / 10",
                            ),
                          ],
                        ),
                      ],
                    ),
                    customSizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.red,
                        ),
                        SizedBox(width: 6),
                        customText(
                          title: movie.releaseDate ?? "",
                          color: Colors.grey,
                        ),
                        customSizedBox(width: 16),
                        Icon(Icons.language, size: 16, color: AppColors.red),
                        customSizedBox(width: 6),
                        customText(
                          title: movie.originalLanguage?.toUpperCase() ?? "",
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    customSizedBox(height: 20),
                    customText(
                      title: "Overview",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    customSizedBox(height: 8),
                    customText(
                      title: movie.overview ?? "No description available.",
                      fontSize: 16,
                      maxLines: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

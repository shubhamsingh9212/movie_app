import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_movies_controller.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/widgets/custom_app_bar.dart';
import 'package:movie_app/widgets/custom_sizedbox.dart';
import 'package:movie_app/widgets/movie_poster.dart';

class BookmarkMoviesView extends GetView<BookmarkMoviesController> {
  const BookmarkMoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customAppBar(title: Strings.BOOKMARK),
            customSizedBox(height: 10),
            Expanded(
              child: moviesGridView(
                scrollController: controller.scrollController,
                movieList: controller.bookMarkMovieList,
                isLoading: controller.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

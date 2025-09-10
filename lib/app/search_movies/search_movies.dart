import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/search_movies/search_movies_controller.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/widgets/custom_app_bar.dart';
import 'package:movie_app/widgets/custom_text_field.dart';
import 'package:movie_app/widgets/movie_poster.dart';

class SearchMoviesView extends GetView<SearchMoviesController> {
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
            customAppBar(title: Strings.WATCH_ME),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 45,
                child: customTextField(
                  controller: controller.searchController,
                  onChanged: (val) => controller.setQuery(val),
                ),
              ),
            ),
            Expanded(
              child: moviesGridView(
                scrollController: controller.scrollController,
                movieList: controller.searchedMovieList,
                isLoading: controller.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

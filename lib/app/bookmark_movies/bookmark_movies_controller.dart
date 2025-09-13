import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/data/enum.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/local_db.dart';
import 'package:movie_app/service/network_requester.dart';

class BookmarkMoviesController extends GetxController {
  RxBool isFetching = false.obs;
  Storage storage = Storage();
  ScrollController scrollController = ScrollController();
  @override
  void onInit() async {
    super.onInit();
    isFetching.value = true;
    await getBookMarkedMovies(forceLoad: true);
    isFetching.value = false;
    scrollListerner();
  }

  RxBool isLoading = false.obs;
  MovieListModel? bookmarkMovies;
  List<Result>? bookmarkMovieList = <Result>[].obs;

  Future<void> getBookMarkedMovies({
    int page = 1,
    bool forceLoad = false,
  }) async {
    if (await isInternetAvailable()) {
      final network = await NetworkRequester.create();
      final response = await network.apiClient.getRequest(
        Urls.BOOKMARKED_MOVIE_LIST,
        query: {
          'language': 'en-US',
          'page': page,
          'sort_by': "created_at.desc",
        },
      );
      if (response != null) {
        MovieListModel? bookmarkMoviesResponse = movieListModelFromJson(
          jsonEncode(response),
        );
        bookmarkMovieList?.addAll(bookmarkMoviesResponse.results ?? []);
        bookmarkMovies = MovieListModel(
          results: bookmarkMovieList,
          page: bookmarkMoviesResponse.page,
          totalPages: bookmarkMoviesResponse.totalPages,
        );
        storage.cacheMovies(
          category: MovieCategory.bookmark.name,
          data: bookmarkMovies?.toHiveModel(),
        );
      }
    } else if (forceLoad) {
      bookmarkMovieList =
          storage
              .getCacheMovies(category: MovieCategory.bookmark.name)
              ?.results;
      bookmarkMovies = storage.getCacheMovies(
        category: MovieCategory.bookmark.name,
      );
    }
    update();
  }

  void scrollListerner() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value &&
            (bookmarkMovies?.page ?? 1) < (bookmarkMovies?.totalPages ?? 0)) {
          isLoading.value = true;
          await getBookMarkedMovies(page: (bookmarkMovies?.page ?? 0) + 1);
          isLoading.value = false;
        }
      }
    });
  }
}

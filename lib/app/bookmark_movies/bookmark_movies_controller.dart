import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_repository.dart';
import 'package:movie_app/base/base_controller.dart';
import 'package:movie_app/data/enum.dart';
import 'package:movie_app/data/model/movie_list_model.dart';
import 'package:movie_app/service/local_db.dart';
import 'package:movie_app/service/network_requester.dart';

class BookmarkMoviesController extends BaseController<BookmarkRepository> {
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
      final response = await repository.getBookMarkedMovies(page: page);
      isFetching.value = false;
      MovieListModel? bookmarkMoviesResponse = response.data;
      if (bookmarkMoviesResponse != null) {
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

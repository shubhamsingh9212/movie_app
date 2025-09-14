import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_movies_controller.dart';
import 'package:movie_app/app/movie_details/movie_details_repository.dart';
import 'package:movie_app/base/base_controller.dart';
import 'package:movie_app/data/enum.dart';
import 'package:movie_app/data/model/movie_list_model.dart';
import 'package:movie_app/data/model/offline_bookmarked_movies.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/service/local_db.dart';
import 'package:movie_app/service/network_requester.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailsController extends BaseController<MovieDetailsRepository> {
  Result movieDetails = Result();
  final Storage storage = Storage();
  RxBool isDataLoading = true.obs;
  RxBool isBookmarked = false.obs;

  @override
  void onInit() async {
    super.onInit();
    dynamic arguments = Get.arguments;
    if (arguments != null) {
      movieDetails = arguments["movie_details"];
      isBookmarked.value = arguments["is_bookmarked"] ?? false;
    }
    isDataLoading.value = true;
    await isMovieBookMarked();
    isDataLoading.value = false;
  }

  Future<void> bookmarkMovie() async {
    if (await isInternetAvailable()) {
      syncOfflineBookmarks();
      onlineBookmark();
    } else {
      offlineBookmark();
    }
    Fluttertoast.showToast(
      msg: Strings.BOOKMARK_UPDATED,
      backgroundColor: AppColors.white,
      textColor: AppColors.red,
      fontSize: 16.0,
    );
  }

  Future<void> onlineBookmark() async {
    isBookmarked.value = !isBookmarked.value;
    final response = await repository.onlineBookmark(
      id: movieDetails.id ?? 0,
      status: isBookmarked.value,
    );
    if (response.data != null) {
      if (Get.isRegistered<BookmarkMoviesController>()) {
        final controller = Get.find<BookmarkMoviesController>();
        controller.bookmarkMovieList?.clear();
        controller.isFetching.value = true;
        await controller.getBookMarkedMovies();
        controller.isFetching.value = false;
      }
      isMovieBookMarked();
    }
  }

  void offlineBookmark() {
    log("ISbookmark : ${isBookmarked.value}");
    final bookmarkMovies =
        storage
            .getCacheMovies(category: MovieCategory.bookmark.name)
            ?.results ??
        [];

    OfflineBookmarkedModel model = OfflineBookmarkedModel(
      id: movieDetails.id,
      isBookmarked: !isBookmarked.value,
    );
    bookmarkMovies.removeWhere((element) => element.id == movieDetails.id);
    if (!isBookmarked.value) {
      bookmarkMovies.insert(0, movieDetails);
    }
    storage.cacheMovies(
      category: MovieCategory.bookmark.name,
      data: MovieListModel(results: bookmarkMovies).toHiveModel(),
    );
    storage.cacheOfflineBookmarkMovie(model);
    isBookmarked.value = !isBookmarked.value;
    if (Get.isRegistered<BookmarkMoviesController>()) {
      final controller = Get.find<BookmarkMoviesController>();
      controller.getBookMarkedMovies(forceLoad: true);
    }
    List<OfflineBookmarkedModel> list = storage.getOfflineBookmarkMovies();
    log("DATA: ${list.map((e) => e.toString()).toList()}");
  }

  Future<void> syncOfflineBookmarks() async {
    List<OfflineBookmarkedModel> offlineBookmarks =
        storage.getOfflineBookmarkMovies();
    if (offlineBookmarks.isEmpty) return;
    for (var bookmark in offlineBookmarks) {
      try {
        await repository.onlineBookmark(
          id: bookmark.id ?? 0,
          status: bookmark.isBookmarked ?? false,
        );
      } catch (e) {
        log('Failed to sync bookmark for movie ${bookmark.id}: $e');
      }
    }
    await storage.offlineBookmarkBox.clear();
  }

  Future<void> isMovieBookMarked() async {
    if (await isInternetAvailable()) {
      final response = await repository.isMovieBookMarked(
        id: movieDetails.id ?? 0,
      );
      if (response.data != null) {
        isBookmarked.value = response.data ?? false;
      }
    } else {
      isBookmarked.value = isOfflineMovieBookmarked(movieDetails.id ?? 0);
    }
  }

  bool isOfflineMovieBookmarked(int movieId) {
    final bookmarkMovies =
        storage
            .getCacheMovies(category: MovieCategory.bookmark.name)
            ?.results ??
        [];

    return bookmarkMovies.any((movie) => movie.id == movieId);
  }

  void shareMovie(BuildContext context) async {
    final String deepLink = "mymoviesapp://movie/${movieDetails.id}";
    final RenderBox box = context.findRenderObject() as RenderBox;
    final result = await SharePlus.instance.share(
      ShareParams(
        text: "Check out this movie: ${movieDetails.title}\n$deepLink",
        title: "Share Movie",
        sharePositionOrigin:
            box.localToGlobal(Offset.zero) & box.size, // Important for iPad!
      ),
    );
  }
}

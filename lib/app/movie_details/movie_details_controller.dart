import 'dart:developer';
import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_movies_controller.dart';
import 'package:movie_app/data/enum.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/model/offline_bookmarked_movies.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/local_db.dart';
import 'package:movie_app/service/network_requester.dart';

class MovieDetailsController extends GetxController {
  Result movieDetails = Result();
  final Storage storage = Storage();

  RxBool isBookmarked = false.obs;

  @override
  void onInit() {
    super.onInit();
    dynamic arguments = Get.arguments;
    if (arguments != null) {
      movieDetails = arguments["movie_details"];
      isBookmarked.value = arguments["is_bookmarked"] ?? false;
    }
    isMovieBookMarked();
  }

  Future<void> bookmarkMovie() async {
    if (await isInternetAvailable()) {
      syncOfflineBookmarks();
      onlineBookmark();
    } else {
      offlineBookmark();
    }
  }

  Future<void> onlineBookmark() async {
    isBookmarked.value = !isBookmarked.value;
    final network = await NetworkRequester.create();
    final response = await network.apiClient.postRequest(
      Urls.BOOKMARK_MOVIE,
      body: {
        "media_type": "movie",
        "media_id": movieDetails.id,
        "watchlist": isBookmarked.value,
      },
    );
    if (response != null) {
      if (Get.isRegistered<BookmarkMoviesController>()) {
        final controller = Get.find<BookmarkMoviesController>();
        controller.bookmarkMovieList?.clear();
        controller.getBookMarkedMovies();
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

    final model = OfflineBookmarkedModel(
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
    final list = storage.getOfflineBookmarkMovies();
    log("DATA: ${list.map((e) => e.toString()).toList()}");
  }

  Future<void> syncOfflineBookmarks() async {
    List<OfflineBookmarkedModel> offlineBookmarks =
        storage.getOfflineBookmarkMovies();
    if (offlineBookmarks.isEmpty) return;
    final network = await NetworkRequester.create();
    for (var bookmark in offlineBookmarks) {
      try {
        await network.apiClient.postRequest(
          Urls.BOOKMARK_MOVIE,
          body: {
            "media_type": "movie",
            "media_id": bookmark.id,
            "watchlist": bookmark.isBookmarked,
          },
        );
      } catch (e) {
        log('Failed to sync bookmark for movie ${bookmark.id}: $e');
      }
    }
    await storage.offlineBookmarkBox.clear();
  }

  Future<void> isMovieBookMarked() async {
    final network = await NetworkRequester.create();
    final response = await network.apiClient.getRequest(
      "${Urls.IS_MOVIE_BOOKMARKED}${movieDetails.id}/account_states",
    );
    if (response != null) {
      isBookmarked.value = response["watchlist"];
    }
  }
}

import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_movies_controller.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/network_requester.dart';

class MovieDetailsController extends GetxController {
  Result movieDetails = Result();
  @override
  void onInit() {
    super.onInit();
    dynamic arguments = Get.arguments;
    if (arguments != null) {
      movieDetails = arguments["movie_details"];
    }
    isMovieBookMarked();
  }

  Future<void> bookmarkMovie() async {
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
        BookmarkMoviesController controller =
            Get.find<BookmarkMoviesController>();
        controller.bookMarkMovieList?.clear();
        controller.getBookMarkedMovies();
      }
      isMovieBookMarked();
    }
  }

  RxBool isBookmarked = false.obs;
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

import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_movies_controller.dart';

class BookmarkMoviesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BookmarkMoviesController>(BookmarkMoviesController());
  }
}

import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_movies_controller.dart';
import 'package:movie_app/app/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<BookmarkMoviesController>(BookmarkMoviesController());
  }
}

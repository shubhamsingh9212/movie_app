import 'package:get/get.dart';
import 'package:movie_app/app/search_movies/search_movies_controller.dart';

class SearchMoviesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SearchMoviesController>(SearchMoviesController());
  }
}

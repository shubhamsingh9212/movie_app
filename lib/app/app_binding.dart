import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_repository.dart';
import 'package:movie_app/app/home/home_repository.dart';
import 'package:movie_app/app/movie_details/movie_details_repository.dart';
import 'package:movie_app/app/search_movies/search_movie_repository.dart';
import '../service/network_requester.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkRequester(), permanent: true);
    Get.put(MovieRepository(), permanent: true);
    Get.put(BookmarkRepository(), permanent: true);
    Get.put(SearchMovieRepository(), permanent: true);
    Get.put(MovieDetailsRepository(), permanent: true);
  }
}

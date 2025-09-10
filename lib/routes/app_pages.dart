import 'package:get/get.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_movies.dart';
import 'package:movie_app/app/bookmark_movies/bookmark_movies_binding.dart';
import 'package:movie_app/app/home/home.dart';
import 'package:movie_app/app/home/home_binding.dart';
import 'package:movie_app/app/movie_details/movie_details.dart';
import 'package:movie_app/app/movie_details/movie_details_binding.dart';
import 'package:movie_app/app/search_movies/search_movies.dart';
import 'package:movie_app/app/search_movies/search_movies_binding.dart';

part 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.MOVIE_DETAILS,
      page: () => const MovieDetailsView(),
      binding: MovieDetailsBinding(),
    ),
    GetPage(
      name: Routes.SEARCH_MOVIES,
      page: () => const SearchMoviesView(),
      binding: SearchMoviesBinding(),
    ),
    GetPage(
      name: Routes.BOOKMARKED_MOVIES,
      page: () => const BookmarkMoviesView(),
      binding: BookmarkMoviesBinding(),
    ),
  ];
}

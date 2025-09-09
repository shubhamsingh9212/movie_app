import 'package:get/get.dart';
import 'package:movie_app/app/home/home.dart';
import 'package:movie_app/app/home/home_binding.dart';
import 'package:movie_app/app/movie_details/movie_details.dart';
import 'package:movie_app/app/movie_details/movie_details_binding.dart';

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
  ];
}

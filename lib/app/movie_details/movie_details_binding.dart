import 'package:get/get.dart';
import 'package:movie_app/app/movie_details/movie_details_controller.dart';

class MovieDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MovieDetailsController>(MovieDetailsController());
  }
}

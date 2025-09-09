import 'package:get/get.dart';
import 'package:movie_app/model/movie_list_model.dart';

class MovieDetailsController extends GetxController {
  Result movieDetails = Result();
  @override
  void onInit() {
    super.onInit();
    dynamic arguments = Get.arguments;
    if (arguments != null) {
      movieDetails = arguments["movie_details"];
    }
  }
}

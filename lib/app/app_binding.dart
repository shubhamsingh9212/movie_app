import 'package:get/get.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import '../service/network_requester.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetworkRequester());
    Get.lazyPut(() => MovieRepository());
  }

}
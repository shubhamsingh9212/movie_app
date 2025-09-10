import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/network_requester.dart';

class BookmarkMoviesController extends GetxController {
  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int totalPages = 1;
  RxBool isLoading = false.obs;
  MovieListModel? bookMarkMoviesResponse;
  RxList<Result>? bookMarkMovieList = <Result>[].obs;
  Future<void> getBookMarkedMovies({int page = 1}) async {
    final network = await NetworkRequester.create();
    final response = await network.apiClient.getRequest(
      Urls.BOOKMARKED_MOVIE_LIST,
      query: {'language': 'en-US', 'page': page,'sort_by':"created_at.desc"},
    );
    if (response != null) {
      bookMarkMoviesResponse = movieListModelFromJson(jsonEncode(response));
      currentPage = bookMarkMoviesResponse?.page ?? 1;
      totalPages = bookMarkMoviesResponse?.totalPages ?? 1;
      bookMarkMovieList?.addAll(bookMarkMoviesResponse?.results ?? []);
    }
  }

  void scrollListerner() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value && currentPage < totalPages) {
          isLoading.value = true;
          await getBookMarkedMovies(page: currentPage + 1);
          isLoading.value = false;
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getBookMarkedMovies();
    scrollListerner();
  }
}

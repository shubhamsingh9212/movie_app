import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/data/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/network_requester.dart';

class SearchMoviesController extends GetxController {
  RxBool isFetching = false.obs;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxString query = "a".obs;
  int currentPage = 1;
  int totalPages = 1;
  RxBool isLoading = false.obs;
  MovieListModel? searchedMoviesResponse;
  RxList<Result>? searchedMovieList = <Result>[].obs;
  Future<void> searchMovies({int page = 1}) async {
    final network = await NetworkRequester.create();
    final response = await network.apiClient.getRequest(
      Urls.SEARCH_MOVIES,
      query: {'query': query, 'language': 'en-US', 'page': page},
    );
    if (response != null) {
      searchedMoviesResponse = movieListModelFromJson(jsonEncode(response));
      currentPage = searchedMoviesResponse?.page ?? 1;
      totalPages = searchedMoviesResponse?.totalPages ?? 1;
      searchedMovieList?.addAll(searchedMoviesResponse?.results ?? []);
    }
  }

  void scrollListerner() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value && currentPage < totalPages) {
          isLoading.value = true;
          await searchMovies(page: currentPage + 1);
          isLoading.value = false;
        }
      }
    });
  }

  void setQuery(String val) {
    query.value = val;
  }

  @override
  void onInit() async {
    super.onInit();
    isFetching.value = true;
    await searchMovies();
    isFetching.value = false;
    debounce(query, (callback) async {
      searchedMovieList?.clear();
      isFetching.value = true;
      await searchMovies();
      isFetching.value = false;
    }, time: Duration(milliseconds: 600));
    scrollListerner();
  }
}

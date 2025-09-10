import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/network_requester.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  List<String> tabTitles = [
    Strings.TRENDING_MOVIES,
    Strings.NOW_PLAYING_MOVIES,
  ];
  RxBool istrendingMoviesLoading = false.obs;
  int trendingCurrentPage = 1;
  int trendingTotalPages = 1;
  MovieListModel? trendingMoviesResponse;
  RxList<Result>? trendingMovieList = <Result>[].obs;
  Future<void> getTrendingMoviesList({int page = 1}) async {
    final network = await NetworkRequester.create();
    final response = await network.apiClient.getRequest(
      Urls.TRENDING_MOVIES,
      query: {'language': 'en-US', 'page': page},
    );
    if (response != null) {
      trendingMoviesResponse = movieListModelFromJson(jsonEncode(response));
      trendingCurrentPage = trendingMoviesResponse?.page ?? 1;
      trendingTotalPages = trendingMoviesResponse?.totalPages ?? 1;
      trendingMovieList?.addAll(trendingMoviesResponse?.results ?? []);
    }
  }

  RxBool isNowPlayingMoviesLoading = false.obs;
  int currentPage = 1;
  int totalPages = 1;
  MovieListModel? nowPlayingMoviesResponse;
  RxList<Result>? nowPlayingMovieList = <Result>[].obs;
  Future<void> getNowPlayingMovies({int page = 1}) async {
    final network = await NetworkRequester.create();
    final response = await network.apiClient.getRequest(
      Urls.NOW_PLAYING_MOVIES,
      query: {'language': 'en-US', 'page': page},
    );
    if (response != null) {
      nowPlayingMoviesResponse = movieListModelFromJson(jsonEncode(response));
      currentPage = nowPlayingMoviesResponse?.page ?? 1;
      totalPages = nowPlayingMoviesResponse?.totalPages ?? 1;
      nowPlayingMovieList?.addAll(nowPlayingMoviesResponse?.results ?? []);
    }
  }

  final ScrollController nowPlayingScrollController = ScrollController();
  void nowPlayingScrollListerner() {
    nowPlayingScrollController.addListener(() async {
      if (nowPlayingScrollController.position.pixels >=
          nowPlayingScrollController.position.maxScrollExtent - 200) {
        if (!isNowPlayingMoviesLoading.value && currentPage < totalPages) {
          isNowPlayingMoviesLoading.value = true;
          await getNowPlayingMovies(page: currentPage + 1);
          isNowPlayingMoviesLoading.value = false;
        }
      }
    });
  }

  final ScrollController trendingScrollController = ScrollController();
  void trendingScrollListerner() {
    trendingScrollController.addListener(() async {
      if (trendingScrollController.position.pixels >=
          trendingScrollController.position.maxScrollExtent - 200) {
        if (!istrendingMoviesLoading.value &&
            trendingCurrentPage < trendingTotalPages) {
          istrendingMoviesLoading.value = true;
          await getTrendingMoviesList(page: trendingCurrentPage + 1);
          istrendingMoviesLoading.value = false;
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    getTrendingMoviesList();
    getNowPlayingMovies();
    nowPlayingScrollListerner();
    trendingScrollListerner();
  }
}

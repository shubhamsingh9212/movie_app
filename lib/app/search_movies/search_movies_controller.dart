import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/network_requester.dart';

class SearchMoviesController extends GetxController {
  late TabController tabController;
  TextEditingController searchController = TextEditingController();
  MovieListModel? nowPlayingMoviesResponse;
  MovieListModel? trendingMoviesResponse;
  RxList<Result>? nowPlayingMovieList = <Result>[].obs;
  RxList<Result>? trendingMovieList = <Result>[].obs;
  RxList<Result>? filteredTrendingMovieList = <Result>[].obs;
  RxList<Result>? filteredNowPlayingMovieList = <Result>[].obs;
  List<String> tabTitles = [
    Strings.TRENDING_MOVIES,
    Strings.NOW_PLAYING_MOVIES,
  ];

  Future<void> getTrendingMoviesList() async {
    final network = await NetworkRequester.create();
    final response = await network.apiClient.getRequest(
      Urls.TRENDING_MOVIES,
      query: {'language': 'en-US', 'page': 1},
    );
    if (response != null) {
      trendingMoviesResponse = movieListModelFromJson(jsonEncode(response));
      trendingMovieList?.value = trendingMoviesResponse?.results ?? [];
      filteredTrendingMovieList?.value = trendingMovieList ?? [];
    }
  }

  Future<void> getNowPlayingMovies() async {
    final network = await NetworkRequester.create();
    final response = await network.apiClient.getRequest(
      Urls.NOW_PLAYING_MOVIES,
      query: {'language': 'en-US', 'page': 1},
    );
    if (response != null) {
      nowPlayingMoviesResponse = movieListModelFromJson(jsonEncode(response));
      nowPlayingMovieList?.value = nowPlayingMoviesResponse?.results ?? [];
      filteredNowPlayingMovieList?.value = nowPlayingMovieList ?? [];
    }
  }

  void searchMovies() {
    final lowerCaseMovieName = searchController.text.trim().toLowerCase();
    filteredTrendingMovieList?.value =
        trendingMovieList?.where((Result element) {
          final title = element.title?.toLowerCase();
          return title?.contains(lowerCaseMovieName) ?? false;
        }).toList() ??
        [];
    filteredNowPlayingMovieList?.value =
        nowPlayingMovieList?.where((Result element) {
          final title = element.title?.toLowerCase();
          return title?.contains(lowerCaseMovieName) ?? false;
        }).toList() ??
        [];
  }

  @override
  void onInit() {
    super.onInit();
    getTrendingMoviesList();
    getNowPlayingMovies();
  }
}

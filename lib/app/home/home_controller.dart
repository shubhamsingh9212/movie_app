import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/data/enum.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/model/hive_movie_list_model.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/network_requester.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late Box<MovieListHiveModel> moviesBox;
  late TabController tabController;
  List<String> tabTitles = [
    Strings.TRENDING_MOVIES,
    Strings.NOW_PLAYING_MOVIES,
  ];

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    moviesBox = await Hive.openBox<MovieListHiveModel>('movies_box');
    getTrendingMoviesList(forceLoad: true);
    trendingScrollListerner();
    getNowPlayingMoviesList(forceLoad: true);
    nowPlayingScrollListerner();
    startInternetListener();
  }

  Future<void> cacheMovies(String category, MovieListHiveModel? data) async {
    final key = category;
    if (data != null) {
      await moviesBox.put(key, data);
    }
  }

  RxBool istrendingMoviesLoading = false.obs;
  MovieListModel? trendingMovies;
  List<Result>? trendingMovieList = <Result>[].obs;
  Future<void> getTrendingMoviesList({
    int page = 1,
    bool forceLoad = false,
  }) async {
    if (await isInternetAvailable()) {
      final network = await NetworkRequester.create();
      final response = await network.apiClient.getRequest(
        Urls.TRENDING_MOVIES,
        query: {'language': 'en-US', 'page': page},
      );
      if (response != null) {
        MovieListModel? trendingMoviesResponse = movieListModelFromJson(
          jsonEncode(response),
        );
        trendingMovieList?.addAll(trendingMoviesResponse.results ?? []);
        trendingMovies = MovieListModel(
          results: trendingMovieList,
          page: trendingMoviesResponse.page,
          totalPages: trendingMoviesResponse.totalPages,
        );
        cacheMovies(MovieCategory.trending.name, trendingMovies?.toHiveModel());
      }
    } else if (forceLoad) {
      trendingMovieList =
          moviesBox.get(MovieCategory.trending.name)?.toOriginalModel().results;
      trendingMovies =
          moviesBox.get(MovieCategory.trending.name)?.toOriginalModel();
    }
    update([Strings.TRENDING_MOVIES]);
  }

  final ScrollController trendingScrollController = ScrollController();
  void trendingScrollListerner() {
    trendingScrollController.addListener(() async {
      if (trendingScrollController.position.pixels >=
          trendingScrollController.position.maxScrollExtent - 200) {
        if (!istrendingMoviesLoading.value &&
            (trendingMovies?.page ?? 1) < (trendingMovies?.totalPages ?? 0)) {
          istrendingMoviesLoading.value = true;
          await getTrendingMoviesList(page: (trendingMovies?.page ?? 0) + 1);
          istrendingMoviesLoading.value = false;
        }
      }
    });
  }

  RxBool isNowPlayingMoviesLoading = false.obs;
  MovieListModel? nowPlayingMovies;
  List<Result>? nowPlayingMovieList = <Result>[].obs;
  Future<void> getNowPlayingMoviesList({
    int page = 1,
    bool forceLoad = false,
  }) async {
    if (await isInternetAvailable()) {
      final network = await NetworkRequester.create();
      final response = await network.apiClient.getRequest(
        Urls.NOW_PLAYING_MOVIES,
        query: {'language': 'en-US', 'page': page},
      );
      if (response != null) {
        MovieListModel? trendingMoviesResponse = movieListModelFromJson(
          jsonEncode(response),
        );
        nowPlayingMovieList?.addAll(trendingMoviesResponse.results ?? []);
        nowPlayingMovies = MovieListModel(
          results: nowPlayingMovieList,
          page: trendingMoviesResponse.page,
          totalPages: trendingMoviesResponse.totalPages,
        );
        cacheMovies(
          MovieCategory.nowPlaying.name,
          nowPlayingMovies?.toHiveModel(),
        );
      }
    } else if (forceLoad) {
      nowPlayingMovieList =
          moviesBox
              .get(MovieCategory.nowPlaying.name)
              ?.toOriginalModel()
              .results;
      nowPlayingMovies =
          moviesBox.get(MovieCategory.nowPlaying.name)?.toOriginalModel();
    }
    update([Strings.NOW_PLAYING_MOVIES]);
  }

  final ScrollController nowPlayingScrollController = ScrollController();
  void nowPlayingScrollListerner() {
    nowPlayingScrollController.addListener(() async {
      if (nowPlayingScrollController.position.pixels >=
          nowPlayingScrollController.position.maxScrollExtent - 200) {
        if (!isNowPlayingMoviesLoading.value &&
            (nowPlayingMovies?.page ?? 1) <
                (nowPlayingMovies?.totalPages ?? 0)) {
          isNowPlayingMoviesLoading.value = true;
          await getNowPlayingMoviesList(
            page: (nowPlayingMovies?.page ?? 0) + 1,
          );
          isNowPlayingMoviesLoading.value = false;
        }
      }
    });
  }

  Future<bool> isInternetAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if ((connectivityResult.isNotEmpty) &&
        (connectivityResult.first == ConnectivityResult.none)) {
      return false;
    }
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void startInternetListener() {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result.first != ConnectivityResult.none) {
        final hasInternet = await isInternetAvailable();
        if (hasInternet) {
          Get.snackbar(
            "Back Online",
            "Movie lists updated.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      }
    });
  }
}

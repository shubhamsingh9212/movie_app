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
  RxBool istrendingMoviesLoading = false.obs;
  MovieListModel? trendingMovies;
  RxList<Result>? trendingMovieList = <Result>[].obs;
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
        cacheMovies(MovieCategory.trending, trendingMovies?.toHiveModel());
      }
    } else if (forceLoad) {
      trendingMovies = moviesBox.get(MovieCategory.trending)?.toOriginalModel();
    }
    update();
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
            (trendingMovies?.page ?? 1) < (trendingMovies?.totalPages ?? 0)) {
          istrendingMoviesLoading.value = true;
          await getTrendingMoviesList(page: (trendingMovies?.page ?? 0) + 1);
          istrendingMoviesLoading.value = false;
        }
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    moviesBox = await Hive.openBox<MovieListHiveModel>('movies_box');
    // moviesIndexBox = await Hive.openBox('movies_index');
    getTrendingMoviesList(forceLoad: true);
    trendingScrollListerner();
    // nowPlayingScrollListerner();
    // startInternetListener();
  }

  // Future<void> loadTrendingMovies({int page = 1}) async {
  //   final hasInternet = await isInternetAvailable();
  //   if (hasInternet) {
  //     await getTrendingMoviesList(page: page);
  //     await _cacheMovies(MovieCategory.trending, page, trendingMovieList ?? []);
  //   }
  // }

  // Future<void> loadNowPlayingMovies({int page = 1}) async {
  //   final hasInternet = await isInternetAvailable();
  //   if (hasInternet) {
  //     await getNowPlayingMovies(page: page);
  //     await _cacheMovies(
  //       MovieCategory.nowPlaying,
  //       page,
  //       nowPlayingMovieList ?? [],
  //     );
  //   } else if (await _isPageCached(MovieCategory.nowPlaying)) {
  //     _loadFromCache(MovieCategory.nowPlaying, page);
  //   }
  // }

  // Future<bool> _isPageCached(MovieCategory category) async {
  //   final key = category;
  //   return moviesIndexBox.containsKey(key);
  // }

  // void _loadFromCache(MovieCategory category) {
  //   final key = category;
  //   final ids = moviesIndexBox.get(key, defaultValue: <int>[]);

  //   List<Result> cachedResults = [];

  //   for (final id in ids) {
  //     final hiveMovie = moviesBox.get(id);
  //     if (hiveMovie != null) cachedResults.add(hiveMovie.toResult());
  //   }

  //   if (category == MovieCategory.trending) {
  //     trendingMovieList?.addAll(cachedResults);
  //     // trendingCurrentPage = page;
  //   } else if (category == MovieCategory.nowPlaying) {
  //     nowPlayingMovieList?.addAll(cachedResults);
  //     // currentPage = page;
  //   }
  // }

  Future<void> cacheMovies(MovieCategory category, MovieListHiveModel? data) async {
    final key = category;
    if (data != null) {
      await moviesBox.put(key, data);
    }
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
      debugPrint("Connectivity result : ${result}");
      if (result.first != ConnectivityResult.none) {
        final hasInternet = await isInternetAvailable();
        if (hasInternet) {
          // await loadTrendingMovies(page: trendingCurrentPage);
          Get.snackbar(
            "Back Online",
            "Movie lists updated.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
        // else {
        //   if (await _isPageCached(MovieCategory.trending)) {
        //     _loadFromCache(MovieCategory.trending);
        //   }
        // }
      }
    });
  }
}

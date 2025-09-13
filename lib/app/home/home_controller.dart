import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/data/enum.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/local_db.dart';
import 'package:movie_app/service/network_requester.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  Storage storage = Storage();
  RxBool isFetching = false.obs;
  late TabController tabController;
  List<String> tabTitles = [
    Strings.TRENDING_MOVIES,
    Strings.NOW_PLAYING_MOVIES,
  ];

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    getInitialData();
    trendingScrollListerner();
    nowPlayingScrollListerner();
    startInternetListener();
  }

  void getInitialData() async {
    isFetching.value = true;
    await getTrendingMoviesList(forceLoad: true);
    await getNowPlayingMoviesList(forceLoad: true);
    isFetching.value = false;
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
        storage.cacheMovies(
          category: MovieCategory.trending.name,
          data: trendingMovies?.toHiveModel(),
        );
      }
    } else if (forceLoad) {
      trendingMovieList =
          storage
              .getCacheMovies(category: MovieCategory.trending.name)
              ?.results;
      trendingMovies = storage.getCacheMovies(
        category: MovieCategory.trending.name,
      );
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
        storage.cacheMovies(
          category: MovieCategory.nowPlaying.name,
          data: nowPlayingMovies?.toHiveModel(),
        );
      }
    } else if (forceLoad) {
      nowPlayingMovieList =
          storage
              .getCacheMovies(category: MovieCategory.nowPlaying.name)
              ?.results;
      nowPlayingMovies = storage.getCacheMovies(
        category: MovieCategory.nowPlaying.name,
      );
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
}

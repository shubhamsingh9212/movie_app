import 'package:hive/hive.dart';
import 'package:movie_app/data/model/hive_movie_list_model.dart';
import 'package:movie_app/data/model/hive_offline_bookmarked_movies.dart';
import 'package:movie_app/data/model/movie_list_model.dart';
import 'package:movie_app/data/model/offline_bookmarked_movies.dart';

class Storage {
  static final Storage _instance = Storage._internal();
  factory Storage() => _instance;

  Storage._internal();

  late Box<MovieListHiveModel> moviesBox;
  late Box<OfflineBookmarkedHiveModel> offlineBookmarkBox;

  Future<void> init() async {
    moviesBox = await Hive.openBox<MovieListHiveModel>('movies_box');
    offlineBookmarkBox = await Hive.openBox<OfflineBookmarkedHiveModel>('offline_bookmark_box');
  }

  Future<void> cacheMovies({
    required String category,
    MovieListHiveModel? data,
  }) async {
    if (data != null) {
      await moviesBox.put(category, data);
    }
  }

  MovieListModel? getCacheMovies({required String category}) {
    return moviesBox.get(category)?.toOriginalModel();
  }

  Future<void> cacheOfflineBookmarkMovie(OfflineBookmarkedModel model) async {
    final key = "movie_${model.id}";
    await offlineBookmarkBox.put(key, model.toHiveModel());
  }

  List<OfflineBookmarkedModel> getOfflineBookmarkMovies() {
    return offlineBookmarkBox.values
        .map((e) => e.toOriginalModel())
        .toList();
  }

  bool containsBookmark(int id) {
    return offlineBookmarkBox.containsKey("movie_$id");
  }

  Future<void> removeOfflineBookmark(int id) async {
    await offlineBookmarkBox.delete("movie_$id");
  }
}

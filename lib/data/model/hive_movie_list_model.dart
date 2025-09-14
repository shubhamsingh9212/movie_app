import 'package:hive/hive.dart';
import 'package:movie_app/data/model/movie_list_model.dart';

part 'hive_movie_list_model.g.dart';

@HiveType(typeId: 0)
class MovieListHiveModel extends HiveObject {
  // @HiveField(0)
  // DatesHiveModel? dates;

  @HiveField(1)
  int? page;

  @HiveField(2)
  List<ResultHiveModel>? results;

  @HiveField(3)
  int? totalPages;

  // @HiveField(4)
  // int? totalResults;

  MovieListHiveModel({
    // this.dates,
    this.page,
    this.results,
    this.totalPages,
    // this.totalResults,
  });
}

@HiveType(typeId: 1)
class DatesHiveModel {
  @HiveField(0)
  DateTime? maximum;

  @HiveField(1)
  DateTime? minimum;

  DatesHiveModel({this.maximum, this.minimum});
}

@HiveType(typeId: 2)
class ResultHiveModel {
  @HiveField(0)
  bool? adult;

  @HiveField(1)
  String? backdropPath;

  @HiveField(2)
  List<int>? genreIds;

  @HiveField(3)
  int? id;

  @HiveField(4)
  String? originalLanguage;

  @HiveField(5)
  String? originalTitle;

  @HiveField(6)
  String? overview;

  @HiveField(7)
  double? popularity;

  @HiveField(8)
  String? posterPath;

  @HiveField(9)
  String? releaseDate;

  @HiveField(10)
  String? title;

  @HiveField(11)
  bool? video;

  @HiveField(12)
  double? voteAverage;

  @HiveField(13)
  int? voteCount;

  ResultHiveModel({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory ResultHiveModel.fromResult(Result result) {
    return ResultHiveModel(
      adult: result.adult,
      backdropPath: result.backdropPath,
      genreIds: result.genreIds,
      id: result.id,
      originalLanguage: result.originalLanguage,
      originalTitle: result.originalTitle,
      overview: result.overview,
      popularity: result.popularity,
      posterPath: result.posterPath,
      releaseDate: result.releaseDate,
      title: result.title,
      video: result.video,
      voteAverage: result.voteAverage,
      voteCount: result.voteCount,
    );
  }

  Result toResult() {
    return Result(
      adult: adult,
      backdropPath: backdropPath,
      genreIds: genreIds,
      id: id,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      releaseDate: releaseDate,
      title: title,
      video: video,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }
}

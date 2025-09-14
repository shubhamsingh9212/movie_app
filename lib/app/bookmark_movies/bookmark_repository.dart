import 'dart:convert';
import 'package:movie_app/base/base_repository.dart';
import 'package:movie_app/data/model/dto/response.dart';
import 'package:movie_app/data/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/exception_handler.dart';

class BookmarkRepository extends BaseRepository {
  Future<RepoResponse<MovieListModel>> getBookMarkedMovies({
    int page = 1,
  }) async {
    final response = await controller.apiClient.getRequest(
      Urls.BOOKMARKED_MOVIE_LIST,
      query: {'language': 'en-US', 'page': page, 'sort_by': "created_at.desc"},
    );
    return response is APIException
        ? RepoResponse(error: response)
        : RepoResponse(data: movieListModelFromJson(jsonEncode(response)));
  }
}

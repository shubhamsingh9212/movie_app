import 'dart:convert';
import 'package:movie_app/base/base_repository.dart';
import 'package:movie_app/data/model/dto/response.dart';
import 'package:movie_app/data/model/movie_list_model.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/exception_handler.dart';

class SearchMovieRepository extends BaseRepository {
  Future<RepoResponse<MovieListModel>> searchMovies({
    int page = 1,
    String query = "",
  }) async {
    final response = await controller.apiClient.getRequest(
      Urls.SEARCH_MOVIES,
      query: {'query': query, 'language': 'en-US', 'page': page},
    );
    return response is APIException
        ? RepoResponse(error: response)
        : RepoResponse(data: movieListModelFromJson(jsonEncode(response)));
  }
}

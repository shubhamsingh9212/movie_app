import 'package:movie_app/base/base_repository.dart';
import 'package:movie_app/data/model/dto/response.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/service/exception_handler.dart';

class MovieDetailsRepository extends BaseRepository {
  Future<RepoResponse<bool>> onlineBookmark({
    required int id,
    required bool status,
  }) async {
    final response = await controller.apiClient.postRequest(
      Urls.BOOKMARK_MOVIE,
      body: {"media_type": "movie", "media_id": id, "watchlist": status},
    );
    return response is APIException
        ? RepoResponse(error: response)
        : RepoResponse(data: true);
  }

  Future<RepoResponse<bool>> isMovieBookMarked({required int id}) async {
    final response = await controller.apiClient.getRequest(
      "${Urls.IS_MOVIE_BOOKMARKED}$id/account_states",
    );
    return response is APIException
        ? RepoResponse(error: response)
        : RepoResponse(data: response["watchlist"]);
  }
}

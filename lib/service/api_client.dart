import 'package:dio/dio.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: Urls.BASEURL)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/{path}")
  Future<dynamic> getRequest(
    @Path("path") String path, {
    @Queries() Map<String, dynamic>? query,
  });

  @POST("/{path}")
  Future<dynamic> postRequest(
    @Path("path") String path, {
    @Body() Map<String, dynamic>? body,
    @Queries() Map<String, dynamic>? query,
  });

  @PUT("/{path}")
  Future<dynamic> putRequest(
    @Path("path") String path, {
    @Body() Map<String, dynamic>? body,
    @Queries() Map<String, dynamic>? query,
  });

  @PATCH("/{path}")
  Future<dynamic> patchRequest(
    @Path("path") String path, {
    @Body() Map<String, dynamic>? body,
    @Queries() Map<String, dynamic>? query,
  });

  @DELETE("/{path}")
  Future<dynamic> deleteRequest(
    @Path("path") String path, {
    @Body() Map<String, dynamic>? body,
    @Queries() Map<String, dynamic>? query,
  });
}

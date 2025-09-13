import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/data/strings.dart';
import 'package:movie_app/routes/urls.dart';
import 'package:movie_app/theme/app_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'api_client.dart';

class NetworkRequester {
  late final ApiClient apiClient;
  late final Dio dio;
  String deviceId = "";
  PackageInfo? packageInfo;

  NetworkRequester._internal();

  static Future<NetworkRequester> create() async {
    final requester = NetworkRequester._internal();
    await requester._init();
    return requester;
  }

  Future<void> _init() async {
    try {
      dio = Dio(
        BaseOptions(
          baseUrl: Urls.BASEURL,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: _getHeaders(),
          responseType: ResponseType.json,
        ),
      );

      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => log(obj.toString()),
        ),
      );

      apiClient = ApiClient(dio);
    } catch (e, st) {
      log("NetworkRequester init error: $e", stackTrace: st);
      rethrow;
    }
  }

  Map<String, dynamic> _getHeaders() {
    return {
      "accept": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmMyNzI3ZThiYTRmOTRmODY1NmQ2MmNlNmQ5ODAwNiIsIm5iZiI6MTc1NzQwMzk3NS4yMjUsInN1YiI6IjY4YmZkYjQ3MTVkNDZlNjU3MDk4YzVhOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.DpO_GnKltBT5QXit2F9XGgnB__hWqmH27oYTyCvQLwM",
      "X-Device-Type": "MOBILE",
      "X-Build-Number": packageInfo?.buildNumber ?? "",
      "X-Device-Id": deviceId,
    };
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
    if (result.first != ConnectivityResult.none) {
      final hasInternet = await isInternetAvailable();
      if (hasInternet) {
        Fluttertoast.showToast(
          msg: Strings.BACK_ONLINE,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: AppColors.white,
          textColor: AppColors.red,
          fontSize: 16.0,
        );
      }
    }
  });
}

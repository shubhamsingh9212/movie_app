// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:movie_app/routes/img_routes.dart';
// import 'package:movie_app/widgets/pop_up.dart';
// import '../widgets/custom_toast.dart';

// class APIException implements Exception {
//   final String message;
//   final int? statusCode;

//   APIException({required this.message, this.statusCode});
// }

// class ExceptionHandler {
//   ExceptionHandler._privateConstructor();

//   static APIException handleError({
//     required Exception error,
//     bool showException = true,
//     dynamic Function()? callApiAgain,
//   }) {
//     // LoginController controller = Get.find<LoginController>();
//     if (error is DioException) {
//       if (error.response?.statusCode == 401) {
//         // controller.refreshToken();
//       }
//       if (error.response?.statusCode == 500) {
//         // Future.delayed(
//         //   Duration.zero,
//         //   () => popUp(
//         //     imageRoute: ImgRoutes.SERVERERROR,
//         //     title: "Server Error",
//         //     content: "Server not responding, Please try again .",
//         //     buttonTitle: "Try Again",
//         //     onPressed: () {
//         //       if (callApiAgain != null) {
//         //         Get.back();
//         //         callApiAgain();
//         //       }
//         //     },
//         //   ),
//         // );
//         customToast(msg: "    Server error    ");

//         return APIException(message: "Server error");
//       } else if ((error.type == DioExceptionType.connectionError) ||
//           (error.type == DioExceptionType.connectionTimeout)) {
//         // Future.delayed(
//         //   Duration.zero,
//         //   () => popUp(
//         //     imageRoute: ImgRoutes.NETWORKERROR,
//         //     title: "Network Error",
//         //     content:
//         //         "Poor network connection detected. Please check your connectivity.",
//         //     buttonTitle: "Try Again",
//         //     onPressed: () {
//         //       if (callApiAgain != null) {
//         //         Get.back();
//         //         callApiAgain();
//         //       }
//         //     },
//         //   ),
//         // );
//         customToast(msg: "     Server not responding   ");
//         return APIException(message: "No internet connection");
//       } else {
//         if (showException &&
//             (json.decode(json.encode(error.response?.data))["error"] != null)) {
//           customToast(
//               msg: json.decode(json.encode(error.response?.data))["error"]);
//         }
//         return APIException(
//             message:
//                 json.decode(json.encode(error.response?.data))["error"] ?? "",
//             statusCode: error.response?.statusCode);
//       }
//     } else {
//       return APIException(message: "error");
//     }
//   }
// }

// class HandleError {
//   HandleError._privateConstructor();

//   static handleError(APIException? error) {
//     customToast(msg: error?.message ?? "Error");
//   }
// }

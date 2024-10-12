import 'dart:developer';

import 'package:dio/dio.dart';

final class Validator {
  const Validator();

  static Future<bool> isConnectedToInternet() async {
    try {
      const int timeOut = 1200;
      // send request ke dns google,
      final response = await Dio().get(
        'https://8.8.8.8',
        options: Options(
          sendTimeout: const Duration(milliseconds: timeOut),
          receiveTimeout: const Duration(milliseconds: timeOut),
        ),
      );

      return (response.statusCode == 200) ? true : false;
    } on DioException catch (error) {
      log("Error on isConnectedToInternet() : $error");
      // jika error karena connection timeout
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return false;
      }
      return false;
    }
  }
}

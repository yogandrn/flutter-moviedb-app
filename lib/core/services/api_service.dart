import 'dart:developer';

import 'package:dio/dio.dart';

import '../configs/constanta_api.dart';

enum DioMethod { post, get, put, delete }

enum ContentType { json, multipartFile }

class ApiService {
  const ApiService();

  /// Method untuk melakukan request HTTP dengan Dio
  static Future<Response> request(
    String endpoint, {
    required DioMethod method,
    required ContentType contentType,
    Map<String, dynamic>? params,
  }) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConst.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          contentType: contentType == ContentType.json
              ? Headers.jsonContentType
              : Headers.multipartFormDataContentType,
        ),
      );
      // untuk membantu log debugging
      // dio.interceptors.add(LogInterceptor(requestBody: true));

      switch (method) {
        case DioMethod.get:
          return await dio.get(
            endpoint,
            queryParameters: params,
          );
        case DioMethod.post:
          return await dio.post(
            endpoint,
            data: params,
          );
        case DioMethod.put:
          return await dio.put(
            endpoint,
            data: params,
          );
        case DioMethod.delete:
          return await dio.delete(
            endpoint,
            queryParameters: params,
          );
        default:
          throw Exception('Method not supported');
      }
    } catch (e) {
      log('Error during request Dio: $e');
      throw Exception('Error on send request to $endpoint : $e');
    }
  }
}

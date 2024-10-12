import 'dart:developer';

import '../../core/configs/constanta_api.dart';
import '../../core/services/api_service.dart';
import '../models/response_detail_movie.dart';
import '../models/response_list_movies.dart';

final class MovieRepository {
  const MovieRepository();

  Future<ResponseListMovies?> getNowPlayingMovies() async {
    try {
      final params = {
        'api_key': ApiConst.apiKey,
      };

      final response = await ApiService.request(
        '/movie/now_playing',
        method: DioMethod.get,
        contentType: ContentType.json,
        params: params,
      );

      return ResponseListMovies.fromJson(response.data);
    } catch (e) {
      log("Error on getNowPlayingMovies() : $e");
      return null;
    }
  }

  Future<ResponseListMovies?> getPopularMovies() async {
    try {
      final params = {
        'api_key': ApiConst.apiKey,
      };

      final response = await ApiService.request(
        '/movie/popular',
        method: DioMethod.get,
        contentType: ContentType.json,
        params: params,
      );

      return ResponseListMovies.fromJson(response.data);
    } catch (e) {
      log("Error on getPopularMovies() : $e");
      return null;
    }
  }

  Future<ResponseListMovies?> getTopRatedMovies() async {
    try {
      final params = {
        'api_key': ApiConst.apiKey,
      };

      final response = await ApiService.request(
        '/movie/top_rated',
        method: DioMethod.get,
        contentType: ContentType.json,
        params: params,
      );

      return ResponseListMovies.fromJson(response.data);
    } catch (e) {
      log("Error on getTopRatedMovies() : $e");
      return null;
    }
  }

  Future<ResponseListMovies?> getRecommendationMovies(int movieID) async {
    try {
      log("Movie Data ID : $movieID");
      final params = {
        'api_key': ApiConst.apiKey,
      };

      final response = await ApiService.request(
        '/movie/$movieID/recommendations',
        method: DioMethod.get,
        contentType: ContentType.json,
        params: params,
      );

      return ResponseListMovies.fromJson(response.data);
    } catch (e) {
      log("Error on getRecommendationMovies() : $e");
      return null;
    }
  }

  Future<ResponseListMovies?> searchMovies(String keyword) async {
    try {
      final query = Uri.parse(keyword);
      final params = {
        'api_key': ApiConst.apiKey,
        'query': query,
      };

      final response = await ApiService.request(
        '/search/movie',
        method: DioMethod.get,
        contentType: ContentType.json,
        params: params,
      );

      return ResponseListMovies.fromJson(response.data);
    } catch (e) {
      log("Error on searchMovies() : $e");
      return null;
    }
  }

  Future<ResponseDetailMovie?> getDetailMovie(int movieID) async {
    try {
      final params = {
        'api_key': ApiConst.apiKey,
      };

      final response = await ApiService.request(
        '/movie/$movieID',
        method: DioMethod.get,
        contentType: ContentType.json,
        params: params,
      );

      return ResponseDetailMovie.fromJson(response.data);
    } catch (e) {
      log("Error on getDetailMovie() : $e");
      return null;
    }
  }
}

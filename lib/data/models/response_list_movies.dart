import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/configs/constanta_api.dart';

ResponseListMovies responseListMoviesFromJson(String str) =>
    ResponseListMovies.fromJson(json.decode(str));

String responseListMoviesToJson(ResponseListMovies data) =>
    json.encode(data.toJson());

class ResponseListMovies {
  Dates? dates;
  int? page;
  List<MovieData> results;
  int? totalPages;
  int? totalResults;
  int statusCode;
  String statusMessage;
  bool success;

  ResponseListMovies({
    this.dates,
    this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
    required this.statusCode,
    required this.statusMessage,
    required this.success,
  });

  factory ResponseListMovies.fromJson(Map<String, dynamic> json) =>
      ResponseListMovies(
        dates: json["dates"] == null ? null : Dates.fromJson(json["dates"]),
        page: json["page"],
        results: json["results"] == null
            ? []
            : List<MovieData>.from(
                json["results"]!.map((x) => MovieData.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
        statusCode: json["status_code"] ?? 200,
        statusMessage: json["status_message"] ?? "Successfully",
        success: json["success"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "dates": dates?.toJson(),
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
        "status_code": statusCode,
        "status_message": statusMessage,
        "success": success,
      };
}

class Dates {
  DateTime? maximum;
  DateTime? minimum;

  Dates({
    this.maximum,
    this.minimum,
  });

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum:
            json["maximum"] == null ? null : DateTime.parse(json["maximum"]),
        minimum:
            json["minimum"] == null ? null : DateTime.parse(json["minimum"]),
      );

  Map<String, dynamic> toJson() => {
        "maximum":
            "${maximum!.year.toString().padLeft(4, '0')}-${maximum!.month.toString().padLeft(2, '0')}-${maximum!.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum!.year.toString().padLeft(4, '0')}-${minimum!.month.toString().padLeft(2, '0')}-${minimum!.day.toString().padLeft(2, '0')}",
      };
}

class MovieData {
  String? backdropPath;
  String uniqueKey;
  int id;
  String? title;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? mediaType;
  bool adult;
  OriginalLanguage? originalLanguage;
  List<int>? genreIds;
  double? popularity;
  String? releaseDate;
  bool video;
  double voteAverage;
  int voteCount;

  MovieData({
    required this.id,
    this.adult = false,
    this.backdropPath,
    this.genreIds,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.mediaType,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.uniqueKey = 'unique',
  });

  factory MovieData.fromJson(Map<String, dynamic> json) => MovieData(
        uniqueKey: UniqueKey().toString(),
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"] == null
            ? null
            : "${ApiConst.prefixAssetUrl}${json["backdrop_path"]}",
        genreIds: json["genre_ids"] == null
            ? []
            : List<int>.from(json["genre_ids"]!.map((x) => x)),
        id: json["id"],
        mediaType: json["media_type"] ?? "movie",
        originalLanguage: originalLanguageValues.map[json["original_language"]],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"],
        posterPath: json["poster_path"] == null
            ? null
            : "${ApiConst.prefixAssetUrl}${json["poster_path"]}",
        releaseDate: "${json["release_date"]}".split("-").first.toString(),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds!.map((x) => x)),
        "id": id,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "media_type": mediaType,
      };
}

enum OriginalLanguage { CN, EN, ES, HI }

final originalLanguageValues = EnumValues({
  "cn": OriginalLanguage.CN,
  "en": OriginalLanguage.EN,
  "es": OriginalLanguage.ES,
  "hi": OriginalLanguage.HI
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

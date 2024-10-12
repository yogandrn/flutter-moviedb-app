import 'dart:convert';

import '../../core/configs/constanta_api.dart';

ResponseDetailMovie responseDetailMovieFromJson(String str) =>
    ResponseDetailMovie.fromJson(json.decode(str));

String responseDetailMovieToJson(ResponseDetailMovie data) =>
    json.encode(data.toJson());

class ResponseDetailMovie {
  int id;
  bool? adult;
  String? backdropPath;
  dynamic belongsToCollection;
  int? budget;
  List<Genre> genres;
  String? homepage;
  String? imdbId;
  List<String>? originCountry;
  String? originalLanguage;
  String originalTitle;
  String overview;
  double? popularity;
  String? posterPath;
  List<ProductionCompany>? productionCompanies;
  List<ProductionCountry>? productionCountries;
  String releaseDate;
  int? revenue;
  int? runtime;
  List<SpokenLanguage>? spokenLanguages;
  String? status;
  String? tagline;
  String title;
  bool? video;
  double voteAverage;
  int voteCount;
  bool success;
  int statusCode;
  String statusMessage;

  ResponseDetailMovie({
    this.adult,
    this.backdropPath,
    this.belongsToCollection,
    this.budget,
    required this.genres,
    this.homepage,
    required this.id,
    this.imdbId,
    this.originCountry,
    this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    required this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    required this.title,
    this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.success,
    required this.statusCode,
    required this.statusMessage,
  });

  factory ResponseDetailMovie.fromJson(Map<String, dynamic> json) =>
      ResponseDetailMovie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"] == null
            ? null
            : "${ApiConst.prefixAssetUrl}${json["backdrop_path"]}",
        belongsToCollection: json["belongs_to_collection"],
        budget: json["budget"] ?? 0,
        genres: json["genres"] == null
            ? []
            : List<Genre>.from(json["genres"]!.map((x) => Genre.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        originCountry: json["origin_country"] == null
            ? []
            : List<String>.from(json["origin_country"]!.map((x) => x)),
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"],
        posterPath: json["poster_path"] == null
            ? null
            : "${ApiConst.prefixAssetUrl}${json["poster_path"]}",
        productionCompanies: json["production_companies"] == null
            ? []
            : List<ProductionCompany>.from(json["production_companies"]!
                .map((x) => ProductionCompany.fromJson(x))),
        productionCountries: json["production_countries"] == null
            ? []
            : List<ProductionCountry>.from(json["production_countries"]!
                .map((x) => ProductionCountry.fromJson(x))),
        releaseDate: "${json["release_date"]}".split("-").first.toString(),
        revenue: json["revenue"] ?? 0,
        runtime: json["runtime"] ?? 0,
        spokenLanguages: json["spoken_languages"] == null
            ? []
            : List<SpokenLanguage>.from(json["spoken_languages"]!
                .map((x) => SpokenLanguage.fromJson(x))),
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"] ?? 0,
        voteCount: json["vote_count"] ?? 0,
        success: json["success"] ?? true,
        statusCode: json["status_code"] ?? 200,
        statusMessage: json["status_message"] ?? "Success",
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "belongs_to_collection": belongsToCollection,
        "budget": budget,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "origin_country": List<dynamic>.from(originCountry!.map((x) => x)),
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "production_companies":
            List<dynamic>.from(productionCompanies!.map((x) => x.toJson())),
        "production_countries":
            List<dynamic>.from(productionCountries!.map((x) => x.toJson())),
        "release_date": releaseDate,
        "revenue": revenue,
        "runtime": runtime,
        "spoken_languages":
            List<dynamic>.from(spokenLanguages!.map((x) => x.toJson())),
        "status": status,
        "tagline": tagline,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "success": success,
        "status_code": statusCode,
        "status_message": statusMessage,
      };
}

class Genre {
  int id;
  String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ProductionCompany {
  int id;
  String? logoPath;
  String name;
  String? originCountry;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      ProductionCompany(
        id: json["id"],
        logoPath: json["logo_path"] == null
            ? null
            : "${ApiConst.prefixAssetUrl}${json["logo_path"]}",
        name: json["name"],
        originCountry: json["origin_country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo_path": logoPath,
        "name": name,
        "origin_country": originCountry,
      };
}

class ProductionCountry {
  String? iso31661;
  String name;

  ProductionCountry({
    this.iso31661,
    required this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(
        iso31661: json["iso_3166_1"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "iso_3166_1": iso31661,
        "name": name,
      };
}

class SpokenLanguage {
  String? englishName;
  String? iso6391;
  String name;

  SpokenLanguage({
    this.englishName,
    this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
        englishName: json["english_name"],
        iso6391: json["iso_639_1"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "english_name": englishName,
        "iso_639_1": iso6391,
        "name": name,
      };
}

// ignore_for_file: unnecessary_this

import 'dart:developer';

class ShowResponse {
  int? page;
  List<Show>? shows;

  ShowResponse({this.page, this.shows});

  ShowResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      shows = <Show>[];
      json['results'].forEach((v) {
        shows!.add(Show.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    if (this.shows != null) {
      data['results'] = this.shows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Show {
  String? backdropPath;
  String? firstAirDate;
  List<int>? genreIds;
  int? id;
  String? mediaType;
  String? name;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String? overview;
  var popularity;
  String? posterPath;
  var voteAverage;
  var voteCount;

  Show(
      {this.backdropPath,
      this.firstAirDate,
      this.genreIds,
      this.id,
      this.mediaType,
      this.name,
      this.originCountry,
      this.originalLanguage,
      this.originalName,
      this.overview,
      this.popularity,
      this.posterPath,
      this.voteAverage,
      this.voteCount});

  Show.fromJson(Map<String, dynamic> json) {
    try {
      backdropPath = json['backdrop_path'];
      firstAirDate = json['first_air_date'];
      genreIds = json['genre_ids']?.cast<int>();
      id = json['id'];
      mediaType = json['media_type'];
      name = json['name'];
      originCountry = json['origin_country']?.cast<String>();
      originalLanguage = json['original_language'];
      originalName = json['original_name'];
      overview = json['overview'];
      popularity = json['popularity'];
      posterPath = json['poster_path'];
      voteAverage = json['vote_average'];
      voteCount = json['vote_count'];
    } on Exception catch (e) {
      log("Show Model $e");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backdrop_path'] = backdropPath;
    data['first_air_date'] = firstAirDate;
    data['genre_ids'] = genreIds;
    data['id'] = id;
    data['media_type'] = mediaType;
    data['name'] = name;
    data['origin_country'] = originCountry;
    data['original_language'] = originalLanguage;
    data['original_name'] = originalName;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}

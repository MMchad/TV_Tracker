// ignore_for_file: unnecessary_this

import 'dart:developer';

class MovieResponse {
  int? page;
  List<Movie>? movies;
  int? totalPages;
  int? totalResults;

  MovieResponse({this.page, this.movies, this.totalPages, this.totalResults});

  MovieResponse.fromJson(Map<String, dynamic> json) {
    try {
      page = json['page'];
      if (json['results'] != null) {
        movies = <Movie>[];
        json['results'].forEach((v) {
          movies!.add(Movie.fromJson(v));
        });
      }
      totalPages = json['total_pages'];
      totalResults = json['total_results'];
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = this.page;
    if (this.movies != null) {
      data['results'] = this.movies!.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = this.totalPages;
    data['total_results'] = this.totalResults;
    return data;
  }
}

class Movie {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? mediaType;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  var popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  var voteAverage;
  var voteCount;
  String? firstAirDate;
  String? name;
  String? originalName;

  Movie(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.mediaType,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.firstAirDate,
      this.name,
      this.originalName});

  Movie.fromJson(Map<String, dynamic> json) {
    try {
      adult = json['adult'];
      backdropPath = json['backdrop_path'];
      genreIds = json['genre_ids']?.cast<int>();
      id = json['id'];
      mediaType = json['media_type'];
      originalLanguage = json['original_language'];
      originalTitle = json['original_title'];
      overview = json['overview'];
      popularity = json['popularity'];
      posterPath = json['poster_path'];
      releaseDate = json['release_date'];
      title = json['title'];
      video = json['video'];
      voteAverage = json['vote_average'];
      voteCount = json['vote_count'];
      firstAirDate = json['first_air_date'];
      name = json['name'];
      originalName = json['original_name'];
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['genre_ids'] = this.genreIds;
    data['id'] = this.id;
    data['media_type'] = this.mediaType;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['overview'] = this.overview;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['release_date'] = this.releaseDate;
    data['title'] = this.title;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['first_air_date'] = this.firstAirDate;
    data['name'] = this.name;
    data['original_name'] = this.originalName;
    return data;
  }
}

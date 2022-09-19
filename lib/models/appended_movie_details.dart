import 'dart:developer';

import 'package:tv_tracker/models/cast.dart';
import 'package:tv_tracker/models/movie_details_model.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/models/reviews_model.dart';

class AppendedMovieDetails {
  MovieDetails? movieDetails;
  Reviews? reviews;
  List<Movie>? similar;
  Cast? cast;
  AppendedMovieDetails({
    this.movieDetails,
    this.reviews,
    this.similar,
    this.cast,
  });

  AppendedMovieDetails.fromJson(Map<String, dynamic> json) {
    try {
      movieDetails = MovieDetails.fromJson(json);
      reviews = Reviews.fromJson(json['reviews'] ?? []);
      if (json['recommendations'] != null) {
        similar = <Movie>[];
        var temp = json['recommendations']['results'] ?? [];
        temp.forEach((v) {
          similar!.add(Movie.fromJson(v));
        });
        cast = Cast.fromJson(json['credits']);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}

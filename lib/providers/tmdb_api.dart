import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tv_tracker/models/appended_movie_details.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/movie_details_model.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:tv_tracker/models/show_details_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/auth/tmdb/api_key.dart';
import 'package:tv_tracker/constants/api_paths.dart';

Future fetchByQuery(String query, String language) async {
  try {
    var response = await http.get(Uri.parse("$api$searchTitleApi?api_key=$apiKey&include_adult=false&query=$query&language=$language"));
    List results = jsonDecode(response.body)["results"] ?? [];
    results = results.where((result) => result["media_type"] != "person").toList();
    results.asMap().forEach((key, value) {
      results[key] = results[key]["title"] != null ? Movie.fromJson(results[key]) : Show.fromJson(results[key]);
    });
    return results;
  } catch (err) {
    log(err.toString());
    return [];
  }
}

Future<List<Show>> fetchPopularShows(int page, String language) async {
  try {
    var response = await http.get(Uri.parse("$api$popularShowsApi?api_key=$apiKey&page=$page&language=$language"));
    ShowResponse showResponse = ShowResponse.fromJson(jsonDecode(response.body));
    return showResponse.shows ?? [];
  } catch (err) {
    log(err.toString());
    return [];
  }
}

Future<List<Movie>> fetchPopularMovies(int page, String language) async {
  try {
    var response = await http.get(Uri.parse("$api$popularMoviesApi?api_key=$apiKey&page=$page&language=$language"));
    MovieResponse movieResponse = MovieResponse.fromJson(jsonDecode(response.body));
    return movieResponse.movies ?? [];
  } catch (err) {
    log(err.toString());
    return [];
  }
}

Future<ShowDetails?> fetchShowDetails(String id, String language) async {
  try {
    final url = "$api$showDetailsApi$id?api_key=$apiKey&language=$language";
    var response = await http.get(Uri.parse(url));
    ShowDetails showDetails = ShowDetails.fromJson(jsonDecode(response.body));
    return showDetails;
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Future<AppendedShowDetails> fetchAppendedShowDetails(String id, String language) async {
  final detailsUrl = "$api$showDetailsApi$id?api_key=$apiKey&append_to_response=reviews,recommendations,credits&language=$language";
  var detailsResponse = await http.get(Uri.parse(detailsUrl));
  AppendedShowDetails showDetails = AppendedShowDetails.fromJson(jsonDecode(detailsResponse.body));
  return showDetails;
}

Future<MovieDetails?> fetchMovieDetails(String id, String language) async {
  try {
    final url = "$api$movieDetailsApi$id?api_key=$apiKey&language=$language";
    var response = await http.get(Uri.parse(url));
    MovieDetails movieDetails = MovieDetails.fromJson(jsonDecode(response.body));
    return movieDetails;
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Future<AppendedMovieDetails> fetchAppendedMovieDetails(String id, String language) async {
  final url = "$api$movieDetailsApi$id?api_key=$apiKey&append_to_response=reviews,recommendations,credits&language=$language";
  var response = await http.get(Uri.parse(url));
  AppendedMovieDetails movieDetails = AppendedMovieDetails.fromJson(jsonDecode(response.body));
  return movieDetails;
}

Future<List<Season>> fetchSeasons(String id, int nbOfSeasons, String language) async {
  try {
    final url = "$api$showDetailsApi$id/season/";
    List<Season> seasons = [];
    for (int i = 1; i <= nbOfSeasons; i++) {
      var response = await http.get(Uri.parse("$url$i?api_key=$apiKey&language=$language"));
      Season season = Season.fromJson(jsonDecode(response.body));
      seasons.add(season);
    }
    return seasons;
  } catch (e) {
    log(e.toString());
    return [];
  }
}

String getAuthorImage(String id) {
  while (id.startsWith('/')) {
    id = id.substring(1);
  }
  if (id.contains("http")) return id;
  return getImageApiUrl(id);
}

String getImageApiUrl(String id, [String? size = "original"]) {
  return "$imagePathApi$size/$id";
}

Future fetchDetailsAndSesaons(String id, String language) {
  var completer = Completer();
  fetchAppendedShowDetails(id, language).then((show) {
    fetchSeasons(show.showDetails!.id!.toString(), show.showDetails?.numberOfSeasons ?? -1, language).then((seasons) {
      completer.complete([show, seasons]);
    });
  });
  return completer.future;
}

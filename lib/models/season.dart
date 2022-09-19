import 'dart:developer';

import 'package:http/http.dart';

class Season {
  String? sId;
  String? airDate;
  List<Episode>? episodes;
  String? name;
  String? overview;
  int? id;
  String? posterPath;
  int? seasonNumber;

  Season({this.sId, this.airDate, this.episodes, this.name, this.overview, this.id, this.posterPath, this.seasonNumber});

  Season.fromJson(Map<String, dynamic> json) {
    try {
      sId = json['_id'];
      airDate = json['air_date'];
      if (json['episodes'] != null) {
        episodes = <Episode>[];
        for (var episode in json['episodes']) {
          episodes!.add(Episode.fromJson(episode));
        }
      }
      id = json['id'];
      name = json['name'];
      overview = json['overview'];
      seasonNumber = json['season_number'];
      posterPath = json['poster_path'];
    } catch (e) {
      log(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['air_date'] = airDate;
    if (episodes != null) {
      data['episodes'] = episodes!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['overview'] = overview;
    data['id'] = id;
    data['poster_path'] = posterPath;
    data['season_number'] = seasonNumber;
    return data;
  }
}

class Episode {
  String? airDate;
  int? episodeNumber;
  int? id;
  String? name;
  String? overview;
  String? productionCode;
  int? runtime;
  int? seasonNumber;
  int? showId;
  String? stillPath;
  double? voteAverage;
  int? voteCount;
  List<Crew>? crew;
  List<GuestStars>? guestStars;

  Episode(
      {this.airDate,
      this.episodeNumber,
      this.id,
      this.name,
      this.overview,
      this.productionCode,
      this.runtime,
      this.seasonNumber,
      this.showId,
      this.stillPath,
      this.voteAverage,
      this.voteCount,
      this.crew,
      this.guestStars});

  Episode.fromJson(Map<String, dynamic> json) {
    try {
      airDate = json['air_date'];
      episodeNumber = json['episode_number'];
      id = json['id'];
      name = json['name'];
      overview = json['overview'];
      productionCode = json['production_code'];
      runtime = json['runtime'];
      seasonNumber = json['season_number'];
      showId = json['show_id'];
      stillPath = json['still_path'];
      voteAverage = json['vote_average'];
      voteCount = json['vote_count'];
      if (json['crew'] != null) {
        List<Crew> crew = [];
        for (var t in json['crew']) {
          crew.add(Crew.fromJson(t));
        }
        ;
      }
      if (json['guest_stars'] != null) {
        List<GuestStars> guestStars = [];
        for (var star in json['guest_stars']) {
          guestStars.add(GuestStars.fromJson(star));
        }
        ;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['air_date'] = airDate;
    data['episode_number'] = episodeNumber;
    data['id'] = id;
    data['name'] = name;
    data['overview'] = overview;
    data['production_code'] = productionCode;
    data['runtime'] = runtime;
    data['season_number'] = seasonNumber;
    data['show_id'] = showId;
    data['still_path'] = stillPath;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    if (crew != null) {
      data['crew'] = crew!.map((v) => v.toJson()).toList();
    }
    if (guestStars != null) {
      data['guest_stars'] = guestStars!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Crew {
  String? department;
  String? job;
  String? creditId;
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;

  Crew(
      {this.department,
      this.job,
      this.creditId,
      this.adult,
      this.gender,
      this.id,
      this.knownForDepartment,
      this.name,
      this.originalName,
      this.popularity,
      this.profilePath});

  Crew.fromJson(Map<String, dynamic> json) {
    try {
      department = json['department'];
      job = json['job'];
      creditId = json['credit_id'];
      adult = json['adult'];
      gender = json['gender'];
      id = json['id'];
      knownForDepartment = json['known_for_department'];
      name = json['name'];
      originalName = json['original_name'];
      popularity = json['popularity'];
      profilePath = json['profile_path'];
    } catch (e) {
      log(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['department'] = department;
    data['job'] = job;
    data['credit_id'] = creditId;
    data['adult'] = adult;
    data['gender'] = gender;
    data['id'] = id;
    data['known_for_department'] = knownForDepartment;
    data['name'] = name;
    data['original_name'] = originalName;
    data['popularity'] = popularity;
    data['profile_path'] = profilePath;
    return data;
  }
}

class GuestStars {
  String? character;
  String? creditId;
  int? order;
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;

  GuestStars(
      {this.character,
      this.creditId,
      this.order,
      this.adult,
      this.gender,
      this.id,
      this.knownForDepartment,
      this.name,
      this.originalName,
      this.popularity,
      this.profilePath});

  GuestStars.fromJson(Map<String, dynamic> json) {
    try {
      character = json['character'];
      creditId = json['credit_id'];
      order = json['order'];
      adult = json['adult'];
      gender = json['gender'];
      id = json['id'];
      knownForDepartment = json['known_for_department'];
      name = json['name'];
      originalName = json['original_name'];
      popularity = json['popularity'];
      profilePath = json['profile_path'];
    } catch (e) {
      log(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['character'] = character;
    data['credit_id'] = creditId;
    data['order'] = order;
    data['adult'] = adult;
    data['gender'] = gender;
    data['id'] = id;
    data['known_for_department'] = knownForDepartment;
    data['name'] = name;
    data['original_name'] = originalName;
    data['popularity'] = popularity;
    data['profile_path'] = profilePath;
    return data;
  }
}

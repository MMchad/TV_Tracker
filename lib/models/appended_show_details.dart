import 'dart:developer';

import 'package:tv_tracker/models/cast.dart';
import 'package:tv_tracker/models/reviews_model.dart';
import 'package:tv_tracker/models/show_details_model.dart';
import 'package:tv_tracker/models/show_model.dart';

class AppendedShowDetails {
  ShowDetails? showDetails;
  Reviews? reviews;
  List<Show>? similar;
  Cast? cast;

  AppendedShowDetails({
    this.showDetails,
    this.reviews,
    this.similar,
    this.cast,
  });

  AppendedShowDetails.fromJson(Map<String, dynamic> json) {
    try {
      showDetails = ShowDetails.fromJson(json);
      reviews = Reviews.fromJson(json['reviews'] ?? []);
      if (json['recommendations'] != null) {
        similar = <Show>[];
        var temp = json['recommendations']['results'] ?? [];
        temp.forEach((v) {
          similar!.add(Show.fromJson(v));
        });

        cast = Cast.fromJson(json['credits']);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}

// ignore_for_file: unused_import

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/firestore_movie_model.dart';
import 'package:tv_tracker/models/firestore_show.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/widgets/episode_tile.dart';
import 'package:tv_tracker/shared/screens/show_details/components/season_tile.dart';

class EpisodesTab extends StatelessWidget {
  final AppendedShowDetails show;
  final List<Season> seasons;
  const EpisodesTab({super.key, required this.show, required this.seasons});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);

    int isSeasonCompleted(Season season, List<String> episodesWatched) {
      List<String> episodesInSeason = (season.episodes ?? []).map((episode) => episode.id.toString()).toList();
      episodesInSeason.removeWhere((episode) => episodesWatched.contains(episode));

      return episodesInSeason.length;
    }

    log(show.showDetails!.id!.toString());
    return StreamBuilder(
        stream: ref.doc(show.showDetails!.id!.toString()).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: (MediaQuery.of(context).size.height) - (MediaQuery.of(context).size.height / 2.2) - 40.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25.h,
                    width: 25.h,
                    child: const CircularProgressIndicator(
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            );
          }
          var data = snapshot.data as DocumentSnapshot;
          Map<String, dynamic>? map = data.data() as Map<String, dynamic>?;
          FirestoreShow firestoreShow = map != null
              ? FirestoreShow.fromJson(map)
              : FirestoreShow(
                  listed: false,
                  type: "Show",
                  watched: [],
                  completed: false,
                  watchedLength: 0,
                  showName: show.showDetails!.name,
                );
          return Column(
            children: [
              for (Season season in seasons)
                SeasonTile(
                  show: show,
                  seasons: seasons,
                  season: season,
                  firestoreShow: firestoreShow,
                  epsNotWatched: isSeasonCompleted(season, firestoreShow.watched ?? []),
                ),
            ],
          );
        });
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/firestore_show.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:tv_tracker/shared/functions/is_show_completed.dart';
import 'package:tv_tracker/shared/widgets/episode_tile.dart';
import 'package:tv_tracker/shared/functions/compare_dates.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SeasonTile extends StatelessWidget {
  const SeasonTile(
      {Key? key, required this.show, required this.seasons, required this.season, required this.firestoreShow, required this.epsNotWatched})
      : super(key: key);
  final AppendedShowDetails show;
  final List<Season> seasons;
  final Season season;
  final FirestoreShow firestoreShow;
  final int epsNotWatched;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
    void markSeason() {
      FirestoreShow newFirestoreShow = firestoreShow;
      var releaseEpisodes = season.episodes!.where((episode) =>
          episode.airDate != null && episode.airDate != "" ? (daysBetween(DateTime.now(), DateTime.parse(episode.airDate!)) <= 0) : false);
      List<String> releasedEpisodeIDs = releaseEpisodes.map((episode) => episode.id.toString()).toList();
      if (epsNotWatched == season.episodes!.length) {
        releasedEpisodeIDs.removeWhere((episode) => newFirestoreShow.watched!.contains(episode));
        newFirestoreShow.watched = newFirestoreShow.watched! + releasedEpisodeIDs;
      } else {
        newFirestoreShow.watched!.removeWhere((episode) => releasedEpisodeIDs.contains(episode));
      }
      newFirestoreShow.watchedLength = newFirestoreShow.watched!.length;
      if (newFirestoreShow.watchedLength! > 0 || newFirestoreShow.listed == true) {
        ref.doc(season.episodes!.first.showId.toString()).set(newFirestoreShow.toJson()).then((value) => isCompleted(firestoreShow, show, seasons));
      } else {
        FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(season.episodes!.first.showId.toString()).delete();
      }
    }

    return Container(
      color: const Color.fromARGB(255, 56, 55, 54),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          iconColor: Colors.white,
          iconSize: 25.h,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          iconPlacement: ExpandablePanelIconPlacement.right,
          hasIcon: true,
          tapBodyToCollapse: false,
        ),
        header: ClipRRect(
          borderRadius: BorderRadius.circular(5.h),
          child: SizedBox(
            height: 60.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => markSeason(),
                    child: Icon(
                      Icons.check_circle,
                      size: 28.h,
                      color: epsNotWatched == 0
                          ? Colors.green
                          : epsNotWatched == season.episodes!.length
                              ? Colors.white
                              : Colors.red,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "   ${AppLocalizations.of(context)!.season} ${season.seasonNumber}",
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Text(
                    "${season.episodes!.length - epsNotWatched}/${season.episodes!.length}",
                    style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 180, 180, 180)),
                  ),
                ],
              ),
            ),
          ),
        ),
        collapsed: Container(),
        expanded: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: (season.episodes?.length ?? [].length) > 100
              ? SizedBox(
                  height: 600.h,
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: season.episodes?.length,
                      itemBuilder: (context, index) {
                        Episode episode = season.episodes![index];
                        return Column(
                          children: [
                            EpisodeTile(
                              show: show,
                              seasons: seasons,
                              episode: episode,
                              firestoreShow: firestoreShow,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (Episode episode in season.episodes ?? []) ...[
                      EpisodeTile(
                        show: show,
                        seasons: seasons,
                        episode: episode,
                        firestoreShow: firestoreShow,
                      ),
                      SizedBox(
                        height: 10.h,
                      )
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

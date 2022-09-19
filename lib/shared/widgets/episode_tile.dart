import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/firestore_show.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/functions/compare_dates.dart';
import 'package:tv_tracker/shared/functions/episode.title.dart';
import 'package:tv_tracker/shared/functions/is_show_completed.dart';
import 'package:tv_tracker/shared/widgets/episode_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EpisodeTile extends StatelessWidget {
  final AppendedShowDetails show;
  final List<Season> seasons;
  final Episode episode;
  final FirestoreShow firestoreShow;
  const EpisodeTile({super.key, required this.seasons, required this.show, required this.episode, required this.firestoreShow});

  @override
  Widget build(BuildContext context) {
    bool watched = firestoreShow.watched!.contains(episode.id.toString());
    int? released;
    if ((episode.airDate ?? "") != "") released = daysBetween(DateTime.now(), DateTime.parse(episode.airDate!));

    handleTap() {
      FirestoreShow temp = firestoreShow;
      watched ? temp.watched!.remove(episode.id.toString()) : temp.watched!.add(episode.id.toString());
      temp.watchedLength = temp.watched!.length;
      final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
      temp.watched!.isEmpty && temp.listed == false
          ? ref.doc(episode.showId.toString()).delete()
          : ref.doc(episode.showId.toString()).set(temp.toJson()).then((value) => isCompleted(firestoreShow, show, seasons));
    }

    return GestureDetector(
      onTap: () => showDialog(context: context, builder: (context) => EpisodeDetailsDialog(show: show, episode: episode)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.h),
        child: Container(
          color: const Color.fromARGB(255, 43, 42, 42),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(255, 70, 70, 70),
                height: 100.h,
                width: 100.h,
                child: episode.stillPath != null
                    ? Image.network(
                        getImageApiUrl(episode.stillPath!, "w300"),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.no_photography,
                        size: 30.h,
                      ),
              ),
              SizedBox(
                width: 15.h,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getEpisodeTitle(episode.episodeNumber!, episode.seasonNumber!),
                        style: GoogleFonts.roboto(fontSize: 19.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        episode.name ?? "",
                        style: GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              (released ?? 1) <= 0
                  ? GestureDetector(
                      onTap: () => handleTap(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 100.h,
                        width: 65.h,
                        color: watched ? Colors.green : Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, anim) => FadeTransition(
                                        opacity: child.key == const ValueKey('icon1')
                                            ? Tween<double>(begin: 1, end: 1).animate(anim)
                                            : Tween<double>(begin: 1, end: 1).animate(anim),
                                        child: ScaleTransition(scale: anim, child: child),
                                      ),
                                  child: watched
                                      ? Icon(
                                          Icons.visibility,
                                          key: const ValueKey('icon1'),
                                          size: 28.sp,
                                          color: const Color.fromARGB(255, 26, 25, 25),
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          key: const ValueKey('icon2'),
                                          size: 28.sp,
                                          color: const Color.fromARGB(255, 26, 25, 25),
                                        )),
                              onPressed: null,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 100.h,
                      width: 65.h,
                      color: const Color.fromARGB(255, 70, 70, 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            released == null ? "?" : "$released",
                            style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            (released ?? 2) > 1 ? AppLocalizations.of(context)!.days : AppLocalizations.of(context)!.day,
                            style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

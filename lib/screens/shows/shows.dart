// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/firestore_show.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:tv_tracker/models/show_details_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/show_details/show_details.dart';
import 'package:tv_tracker/shared/screens/show_list/show_list.dart';
import 'package:tv_tracker/shared/widgets/episode_tile.dart';
import 'package:tv_tracker/shared/widgets/loading_indicator.dart';
import 'package:tv_tracker/shared/widgets/outlined_icon_button.dart';
import 'package:tv_tracker/shared/widgets/placeholder_episode_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Shows extends StatefulWidget {
  const Shows({super.key});

  @override
  State<Shows> createState() => _ShowsState();
}

class _ShowsState extends State<Shows> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverAppBar(
        pinned: true,
        floating: false,
        toolbarHeight: 50.h,
        backgroundColor: const Color.fromARGB(255, 26, 25, 25),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.trackedShows,
          style: GoogleFonts.roboto(fontSize: 22.h, fontWeight: FontWeight.bold),
        ),
      ),
      SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.only(top: 15.h, left: 15.h, right: 15.h),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc("Tracking").snapshots(),
            builder: (context, snapshot) {
              Widget s1;
              if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                s1 = const LoadingIndicator(raidus: 25);
                return s1;
              }
              var data = snapshot.data as DocumentSnapshot;
              if (data.data() != null) {
                Map<String, dynamic> tracking = (data.data() ?? {}) as Map<String, dynamic>;
                if (tracking.isNotEmpty) {
                  s1 = Column(
                    children: [
                      for (String id in tracking.keys)
                        SizedBox(
                          child: Column(
                            children: [
                              FutureBuilder(
                                  future: fetchShowDetails(
                                    id,
                                    Localizations.localeOf(context).languageCode,
                                  ),
                                  builder: (context, future) {
                                    if (future.connectionState == ConnectionState.done && future.hasData) {
                                      ShowDetails show = future.data as ShowDetails;
                                      return OutlinedTextButton(text: show.name!);
                                    }
                                    return const OutlinedTextButton(text: "");
                                  }),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(id).snapshots(),
                                builder: (context, snapshot) {
                                  Widget s2;
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    s2 = Column(
                                      children: [
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        const PlaceholderEpisodeTile(),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                      ],
                                    );
                                  } else {
                                    DocumentSnapshot doc = snapshot.data as DocumentSnapshot;
                                    s2 = FutureBuilder(
                                        future: fetchDetailsAndSesaons(
                                          doc.id,
                                          Localizations.localeOf(context).languageCode,
                                        ),
                                        builder: (context, future) {
                                          Widget f1;
                                          if (future.connectionState == ConnectionState.done && future.data != null) {
                                            FirestoreShow firestoreShow = FirestoreShow.fromJson(doc.data() as Map<String, dynamic>);
                                            AppendedShowDetails show = (future.data as List).first as AppendedShowDetails;
                                            List<Season> showSeasons = (future.data as List).last as List<Season>;
                                            List<Episode> episodes = [];
                                            for (Season season in showSeasons) {
                                              episodes.addAll(season.episodes!.toList());
                                            }
                                            int nextEpisode;
                                            List<Episode> unwatchedEpisodes = [];
                                            List<String> episodeIDs = episodes.map((episode) => episode.id.toString()).toList();
                                            unwatchedEpisodes
                                                .add(episodes.firstWhere((episode) => !firestoreShow.watched!.contains(episode.id.toString())));
                                            f1 = Column(
                                              children: [
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                EpisodeTile(
                                                    show: show, episode: unwatchedEpisodes.first, firestoreShow: firestoreShow, seasons: showSeasons),
                                                SizedBox(
                                                  height: 15.h,
                                                )
                                              ],
                                            );
                                          } else {
                                            f1 = Column(
                                              children: [
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                PlaceholderEpisodeTile(),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                              ],
                                            );
                                          }
                                          return AnimatedSwitcher(duration: const Duration(milliseconds: 100), child: f1);
                                        });
                                  }
                                  return AnimatedSwitcher(duration: const Duration(milliseconds: 100), child: s2);
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                } else {
                  s1 = const ShowListEmpty();
                }
              } else {
                s1 = const ShowListEmpty();
              }

              return s1;
            },
          ),
        ),
      ),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}

class OutlinedTextButton extends StatelessWidget {
  const OutlinedTextButton({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23.h,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 43, 42, 42)),
          side: MaterialStateProperty.all(
            BorderSide(color: Colors.transparent, width: 2.h),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.h),
            ),
          ),
        ),
        onPressed: null,
        child: Text(
          text,
          style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.greenAccent),
        ),
      ),
    );
  }
}

class ShowListEmpty extends StatelessWidget {
  const ShowListEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.noTrackedShows,
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        OutlinedIconButton(
          title: AppLocalizations.of(context)!.discoverShows,
          icon: Icons.search,
          fillColor: Colors.greenAccent,
          textColor: Colors.black,
          iconColor: Colors.black,
          borderColor: Colors.transparent,
          iconSize: 26,
          fontSize: 18,
          onPress: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowList())),
        )
      ],
    );
  }
}

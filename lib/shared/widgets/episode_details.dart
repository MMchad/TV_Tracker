import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/functions/episode.title.dart';
import 'package:tv_tracker/shared/screens/show_details/show_details.dart';
import 'package:tv_tracker/shared/widgets/details_divider.dart';
import 'package:tv_tracker/shared/widgets/rating_circular_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EpisodeDetailsDialog extends StatelessWidget {
  final AppendedShowDetails show;
  final Episode episode;
  const EpisodeDetailsDialog({super.key, required this.show, required this.episode});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.8,
          color: const Color.fromARGB(255, 43, 42, 42),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Stack(
                children: [
                  Container(
                    height: 200.h,
                    color: Colors.black,
                    child: SizedBox(
                      height: 200.h,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: episode.stillPath != null
                          ? CachedNetworkImage(
                              color: Colors.black.withOpacity(0.6),
                              colorBlendMode: BlendMode.darken,
                              imageUrl: getImageApiUrl(episode.stillPath!),
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.no_photography,
                              size: 55.h,
                            ),
                    ),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () async {
                        Show newShow = Show.fromJson(show.showDetails!.toJson());
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDetailsScreen(show: newShow)));
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h, top: 10.h),
                          child: Text(
                            "${show.showDetails!.name!} >",
                            style: GoogleFonts.roboto(fontSize: 17.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ListTile(
                        title: Text(
                          getEpisodeTitle(episode.episodeNumber!, episode.seasonNumber!),
                          style: GoogleFonts.roboto(fontSize: 19.sp, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          episode.name ?? "",
                          style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w500),
                        ),
                        trailing: RatingCircularIndicator(
                          rating: episode.voteAverage?.toDouble(),
                          fontSize: 15,
                          radius: 37,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailsDivider(
                      details: episode.airDate != null && episode.airDate != "" ? episode.airDate : "Unknown air date",
                      divide: true,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    Text(
                      episode.overview == "" ? AppLocalizations.of(context)!.noOverview : episode.overview ?? "No overview available.",
                      style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w400),
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

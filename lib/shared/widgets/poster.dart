import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tv_tracker/models/cast.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/screens/movie_details/movie_details.dart';
import 'package:tv_tracker/shared/screens/show_details/show_details.dart';

class Poster extends StatelessWidget {
  final media;
  final double height;
  const Poster({super.key, required this.media, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, _) => media is Show
          ? ShowDetailsScreen(
              show: media,
            )
          : MovieDetailsScreen(
              movie: media,
            ),
      openColor: ThemeData.dark().focusColor,
      closedColor: ThemeData.dark().focusColor,
      tappable: media is Show || media is Movie ? true : false,
      closedBuilder: (context, openContainer) => (media is Actor ? media.profilePath : (media.posterPath ?? media.backdropPath)) != null
          ? CachedNetworkImage(
              placeholder: (context, value) {
                return Shimmer.fromColors(
                  period: const Duration(milliseconds: 700),
                  baseColor: const Color.fromARGB(255, 70, 70, 70),
                  highlightColor: const Color.fromARGB(255, 116, 115, 115),
                  child: SizedBox(
                    height: height,
                    width: height * 0.6666666666666667,
                  ),
                );
              },
              imageUrl: getImageApiUrl(media is Actor ? media.profilePath : (media.posterPath ?? media.backdropPath), "w500"),
              fit: BoxFit.contain,
            )
          : SizedBox(
              height: height,
              width: height * 0.6666666666666667,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.no_photography,
                  size: height / 5,
                ),
                Text(
                  media.name ?? media.title ?? "",
                  style: GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
    );
  }
}

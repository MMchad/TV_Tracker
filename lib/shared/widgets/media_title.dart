import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_movie_details.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/movie_details_model.dart';
import 'package:tv_tracker/models/show_details_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/widgets/rating_circular_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MediaTitle extends StatelessWidget {
  final media;
  final Future mediaDetails;
  final double titleFontSize;
  final double subFontsize;
  final double radius;
  final double ratingFontSize;
  final double strokeWidth;
  const MediaTitle(
      {Key? key,
      required this.media,
      required this.mediaDetails,
      this.titleFontSize = 13,
      this.subFontsize = 12,
      this.radius = 35,
      this.ratingFontSize = 14,
      this.strokeWidth = 5})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String showTitle(AsyncSnapshot<Object?> future) {
      ShowDetails response = (future.data as AppendedShowDetails).showDetails as ShowDetails;
      String info = "";
      if (response.tagline != "") info = "$info${response.tagline}\n";
      info = response.numberOfSeasons == 1
          ? "$info${response.numberOfSeasons} ${AppLocalizations.of(context)!.season}"
          : "$info${response.numberOfSeasons} ${AppLocalizations.of(context)!.seasons}";
      if (response.status! == "Ended") info = "$info - Ended";
      return info;
    }

    String movieTitle(AsyncSnapshot<Object?> future) {
      MovieDetails response = (future.data as AppendedMovieDetails).movieDetails as MovieDetails;
      String info = "";
      if (response.tagline != "") info = "$info${response.tagline}\n";
      if (response.releaseDate?.isNotEmpty ?? false) {
        if (response.status?.toString() == "Released") {
          info = "$info${AppLocalizations.of(context)!.released} ${response.releaseDate?.substring(0, 4) ?? ""}";
        } else {
          info = "$info${AppLocalizations.of(context)!.releases} ${response.releaseDate?.substring(0, 4) ?? ""}";
        }
      }
      return info;
    }

    return ListTile(
      title: Text(
        media.name ?? media.title ?? "",
        style: GoogleFonts.roboto(
          fontSize: titleFontSize.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: FutureBuilder(
        future: mediaDetails,
        builder: (context, future) {
          if (future.data != null) {
            final info = media is Show ? showTitle(future) : movieTitle(future);
            return Text(
              info,
              style: GoogleFonts.roboto(fontSize: subFontsize.sp),
            );
          }
          return const Text(" ");
        },
      ),
      trailing: RatingCircularIndicator(
        rating: media.voteAverage?.toDouble(),
        fontSize: ratingFontSize,
        radius: radius,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

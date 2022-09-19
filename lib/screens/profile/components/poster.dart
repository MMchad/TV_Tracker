import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/cast.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/screens/movie_details/movie_details.dart';
import 'package:tv_tracker/shared/screens/show_details/show_details.dart';

class ProfilePoster extends StatelessWidget {
  final media;
  final double height;
  const ProfilePoster({super.key, required this.media, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => media is Show
              ? ShowDetailsScreen(
                  show: media,
                )
              : MovieDetailsScreen(
                  movie: media,
                ),
        ),
      ),
      child: Container(
        child: media is Actor
            ? media.profilePath
            : (media.posterPath ?? media.backdropPath) != null
                ? CachedNetworkImage(
                    placeholder: (context, value) {
                      return SizedBox(
                        height: height,
                        width: height * 0.6666666666666667,
                      );
                    },
                    imageUrl: getImageApiUrl(media is Actor ? media.profilePath : (media.posterPath ?? media.backdropPath), "w500"),
                    fit: BoxFit.contain,
                  )
                : SizedBox(
                    height: height,
                    width: height * 0.6666666666666667,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.no_photography,
                          size: height / 5,
                        ),
                        Text(
                          media.name ?? media.title ?? "",
                          style: GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

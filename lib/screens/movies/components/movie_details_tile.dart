import 'package:flutter/material.dart';
import 'package:tv_tracker/models/appended_movie_details.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/movie_details/movie_details.dart';
import 'package:tv_tracker/shared/widgets/media_background_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/widgets/media_title.dart';

class MovieDetailsTile extends StatelessWidget {
  final AppendedMovieDetails movie;
  const MovieDetailsTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: Movie.fromJson(movie.movieDetails!.toJson())))),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3.h),
          child: Stack(
            children: [
              MediaBackgroundImage(
                height: 300.h,
                width: MediaQuery.of(context).size.width - 30,
                media: movie.movieDetails,
                fullShadow: true,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MediaTitle(
                    media: movie.movieDetails,
                    titleFontSize: 22,
                    subFontsize: 17,
                    radius: 40,
                    ratingFontSize: 17,
                    mediaDetails: Future(() => movie),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

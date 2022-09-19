import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/models/appended_movie_details.dart';
import 'package:tv_tracker/models/movie_details_model.dart';
import 'package:tv_tracker/shared/widgets/actor_list.dart';
import 'package:tv_tracker/shared/widgets/details_divider.dart';
import 'package:tv_tracker/shared/widgets/media_options.dart';
import 'package:tv_tracker/shared/widgets/poster.dart';
import 'package:tv_tracker/shared/widgets/reviews_view.dart';
import 'package:tv_tracker/shared/widgets/similar_to_list.dart';

class MovieDetailsBody extends StatefulWidget {
  final AppendedMovieDetails movieDetails;
  const MovieDetailsBody({super.key, required this.movieDetails});

  @override
  State<MovieDetailsBody> createState() => _MovieDetailsBodyState();
}

class _MovieDetailsBodyState extends State<MovieDetailsBody> {
  var nbOfReviews = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 15.h, right: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.movieDetails.movieDetails?.productionCompanies?.isNotEmpty ?? false)
            DetailsDivider(
              details: widget.movieDetails.movieDetails!.productionCompanies!.first.name,
              divide: true,
            ),
          if (widget.movieDetails.movieDetails?.productionCompanies?.isNotEmpty ?? false)
            DetailsDivider(
              details: widget.movieDetails.movieDetails!.genres!.first.name,
              divide: true,
            ),
          if ((widget.movieDetails.movieDetails?.overview ?? false) != "")
            DetailsDivider(
              details: widget.movieDetails.movieDetails!.overview!,
              divide: true,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          if (widget.movieDetails.cast?.cast?.isNotEmpty ?? false)
            ActorsList(
              cast: widget.movieDetails.cast!.cast!,
            ),
          if (widget.movieDetails.similar?.isNotEmpty ?? false)
            SimilarToList(
              media: widget.movieDetails.similar!,
            ),
          if (widget.movieDetails.reviews?.reviews?.isNotEmpty ?? false)
            const DetailsDivider(
              details: "User reviews",
              divide: false,
            ),
          if (widget.movieDetails.reviews?.reviews?.isNotEmpty ?? false)
            SizedBox(
              height: 25.h,
            ),
          for (var review in widget.movieDetails.reviews!.reviews!.sublist(0, min(nbOfReviews, widget.movieDetails.reviews!.reviews!.length)))
            ReviewView(review: review),
          (widget.movieDetails.reviews?.reviews?.length ?? 0) > nbOfReviews
              ? Padding(
                  padding: EdgeInsets.all(8.h),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        nbOfReviews++;
                      });
                    },
                    child: Center(
                      child: Text(
                        "See more",
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(height: 25.h),
        ],
      ),
    );
  }
}

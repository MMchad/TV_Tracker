import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/models/cast.dart';
import 'package:tv_tracker/screens/shows/shows.dart';
import 'package:tv_tracker/shared/widgets/actor_card.dart';
import 'package:tv_tracker/shared/widgets/actor_list.dart';
import 'package:tv_tracker/shared/widgets/details_divider.dart';
import 'package:tv_tracker/shared/widgets/poster.dart';
import 'package:tv_tracker/shared/widgets/reviews_view.dart';
import 'package:tv_tracker/shared/widgets/similar_to_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowDetailsTab extends StatefulWidget {
  final AppendedShowDetails showDetails;
  const ShowDetailsTab({super.key, required this.showDetails});

  @override
  State<ShowDetailsTab> createState() => _ShowDetailsTabState();
}

class _ShowDetailsTabState extends State<ShowDetailsTab> {
  var nbOfReviews = 2;

  getReviews(int maxNbOfReviews) {
    var reviewWigetList = [];
    if (widget.showDetails.reviews?.reviews?.isNotEmpty ?? false) {
      for (var review in widget.showDetails.reviews!.reviews!) {
        if (maxNbOfReviews == widget.showDetails.reviews!.reviews!.indexOf(review)) break;
        reviewWigetList.add(
          Column(
            children: [
              if (widget.showDetails.reviews!.reviews!.indexOf(review) > 0) const DetailsDivider(details: "", divide: true),
              ReviewView(review: review),
            ],
          ),
        );
      }
      return reviewWigetList;
    } else {
      return [
        Row(
          children: [
            Expanded(
              child: Text(
                "No Reviews",
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showDetails.showDetails?.networks?.isNotEmpty ?? false)
          DetailsDivider(
            details: widget.showDetails.showDetails!.networks?.first.name,
            divide: true,
          ),
        if (widget.showDetails.showDetails?.genres?.isNotEmpty ?? false)
          DetailsDivider(
            details: widget.showDetails.showDetails!.genres?.first.name,
            divide: true,
          ),
        if (widget.showDetails.showDetails!.firstAirDate != "")
          DetailsDivider(
            details:
                "${widget.showDetails.showDetails!.firstAirDate?.substring(0, 4)} - ${widget.showDetails.showDetails!.status == "Ended" ? widget.showDetails.showDetails!.lastAirDate?.substring(0, 4) : AppLocalizations.of(context)!.present}",
            divide: true,
          ),
        if (widget.showDetails.showDetails?.overview != "")
          DetailsDivider(
            details: widget.showDetails.showDetails!.overview,
            divide: true,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        if (widget.showDetails.cast?.cast?.isNotEmpty ?? false)
          ActorsList(
            cast: widget.showDetails.cast!.cast!,
          ),
        if (widget.showDetails.similar?.isNotEmpty ?? false) SimilarToList(media: widget.showDetails.similar!),
        if (widget.showDetails.reviews?.reviews?.isNotEmpty ?? false)
          DetailsDivider(
            details: AppLocalizations.of(context)!.userReviews,
            divide: false,
          ),
        if (widget.showDetails.reviews?.reviews?.isNotEmpty ?? false)
          SizedBox(
            height: 25.h,
          ),
        for (var review in widget.showDetails.reviews!.reviews!.sublist(0, min(nbOfReviews, widget.showDetails.reviews!.reviews!.length)))
          ReviewView(review: review),
        (widget.showDetails.reviews?.reviews?.length ?? 0) > nbOfReviews
            ? Padding(
                padding: EdgeInsets.all(8.h),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      nbOfReviews++;
                    });
                  },
                  child: Text(
                    "See more",
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              )
            : SizedBox(height: 25.h),
      ],
    );
  }
}

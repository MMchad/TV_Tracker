import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/reviews_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/widgets/details_divider.dart';
import 'package:tv_tracker/shared/widgets/rating_circular_indicator.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReviewView extends StatelessWidget {
  final Review review;
  const ReviewView({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 65.h,
                width: 65.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(300.0),
                  child: review.authorDetails?.avatarPath != null
                      ? Image.network(
                          getAuthorImage(review.authorDetails!.avatarPath!),
                          fit: BoxFit.fill,
                        )
                      : Icon(
                          Icons.person,
                          size: 50.h,
                        ),
                )),
            Expanded(
              child: Padding(
                padding: Directionality.of(context) == TextDirection.rtl ? EdgeInsets.only(right: 15.h) : EdgeInsets.only(left: 15.h),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        review.author ?? "Unknown",
                        style: GoogleFonts.roboto(fontSize: 15.sp),
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Text(
                        review.updatedAt?.substring(0, 10) ?? "",
                        style: GoogleFonts.roboto(fontSize: 13.sp),
                        textAlign: TextAlign.start,
                      ),
                      trailing: RatingCircularIndicator(
                        rating: review.authorDetails?.rating,
                        fontSize: 15,
                        strokeWidth: 4,
                        radius: 40,
                      ),
                    ),
                    ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: MarkdownBody(
                          data: review.content!,
                          shrinkWrap: true,
                          styleSheet: MarkdownStyleSheet(textScaleFactor: 1.h),
                        )

                        // Text(
                        //    ,
                        //   style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.normal),
                        //   textAlign: TextAlign.start,
                        // ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const DetailsDivider(details: "", divide: true),
      ],
    );
  }
}

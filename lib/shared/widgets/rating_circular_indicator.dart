import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/shared/functions/evaluate_rating_color.dart';

class RatingCircularIndicator extends StatelessWidget {
  final double? rating;
  final double radius;
  final double strokeWidth;
  final double fontSize;
  final FontWeight fontWeight;

  const RatingCircularIndicator({
    Key? key,
    required this.rating,
    this.radius = 35,
    this.strokeWidth = 5,
    this.fontSize = 14,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (radius + 10).h,
      width: (radius + 10).h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: radius.h,
                width: radius.h,
                child: CircularProgressIndicator(
                  value: (rating ?? 0) / 10,
                  color: EvaluateRatingColor(rating ?? 0),
                  strokeWidth: strokeWidth.h,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                (rating ?? 0.0) == 0 ? "?" : rating!.toStringAsFixed(1),
                style: GoogleFonts.roboto(fontSize: fontSize.sp, fontWeight: fontWeight),
              ),
            ),
          )
        ],
      ),
    );
  }
}

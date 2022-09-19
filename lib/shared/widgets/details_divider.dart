import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/movie_details_model.dart';

class DetailsDivider extends StatelessWidget {
  final String? details;
  final bool divide;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double thickness;
  final Color color;

  const DetailsDivider({
    super.key,
    this.details,
    this.divide = true,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.height = 25,
    this.thickness = 1,
    this.color = Colors.white24,
  });

  @override
  Widget build(BuildContext context) {
    return details != null
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      details!,
                      style: GoogleFonts.roboto(fontSize: fontSize.sp, fontWeight: fontWeight),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              if (divide)
                Divider(
                  height: height.h,
                  color: color,
                  thickness: thickness.h,
                ),
            ],
          )
        : Container();
  }
}

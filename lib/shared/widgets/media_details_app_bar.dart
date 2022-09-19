import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/shared/widgets/media_background_image.dart';
import 'package:tv_tracker/shared/widgets/media_title.dart';

class DetailsAppBar extends StatelessWidget {
  var media;
  Future mediaDetails;
  DetailsAppBar({
    Key? key,
    required this.media,
    required this.mediaDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Stack(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 39.sp,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 35.sp,
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 46, 45, 45),
      stretch: true,
      pinned: true,
      snap: false,
      floating: false,
      toolbarHeight: 50.h,
      collapsedHeight: 70.h,
      expandedHeight: MediaQuery.of(context).size.height / 2.2,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: Directionality.of(context) == TextDirection.rtl ? EdgeInsets.only(right: 35.h) : EdgeInsets.only(left: 35.h),
        expandedTitleScale: 1.3,
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        title: MediaTitle(
          media: media,
          mediaDetails: mediaDetails,
          titleFontSize: 15,
          subFontsize: 13,
          radius: 35,
          strokeWidth: 5,
          ratingFontSize: 14,
        ),
        background: MediaBackgroundImage(
          media: media,
          height: MediaQuery.of(context).size.height / 2.2,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

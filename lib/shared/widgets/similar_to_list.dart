import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/widgets/details_divider.dart';
import 'package:tv_tracker/shared/widgets/poster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SimilarToList extends StatelessWidget {
  const SimilarToList({
    Key? key,
    required this.media,
  }) : super(key: key);

  final List media;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailsDivider(
          details: AppLocalizations.of(context)!.similarTo,
          divide: false,
        ),
        SizedBox(
          height: 20.h,
        ),
        SizedBox(
          height: 200.h,
          child: ListView(
            addAutomaticKeepAlives: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              for (var item in media)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.h),
                  child: Poster(
                    media: item,
                    height: 200.h,
                  ),
                ),
            ],
          ),
        ),
        const DetailsDivider(details: "", divide: true),
      ],
    );
  }
}

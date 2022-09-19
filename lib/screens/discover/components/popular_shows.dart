import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/show_list/show_list.dart';
import 'package:tv_tracker/shared/widgets/placeholder_poster.dart';
import 'package:tv_tracker/shared/widgets/poster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopularShows extends StatelessWidget {
  const PopularShows({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.popularShows,
                style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowList()));
                },
                child: Text(
                  AppLocalizations.of(context)!.seeMore,
                  style: GoogleFonts.roboto(fontSize: 18.sp, color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: fetchPopularShows(
              1,
              Localizations.localeOf(context).languageCode,
            ),
            builder: (context, future) {
              if (future.connectionState == ConnectionState.done) {
                List<Show> shows = future.data as List<Show>;
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var show in shows)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.sp),
                          child: Poster(
                            media: show,
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                        )
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [for (var i = 0; i < 20; i++) const PlaceholderPoster()],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

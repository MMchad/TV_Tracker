import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/move_list/movie_list.dart';
import 'package:tv_tracker/shared/widgets/placeholder_poster.dart';
import 'package:tv_tracker/shared/widgets/poster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopularMovies extends StatelessWidget {
  const PopularMovies({
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
                AppLocalizations.of(context)!.popularMovies,
                style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MovieList()));
                },
                child: Text(
                  AppLocalizations.of(context)!.seeMore,
                  style: GoogleFonts.roboto(fontSize: 18.sp, color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          FutureBuilder(
            future: fetchPopularMovies(
              1,
              Localizations.localeOf(context).languageCode,
            ),
            builder: (context, future) {
              if (future.connectionState == ConnectionState.done) {
                List<Movie> movies = future.data as List<Movie>;
                return SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: ListView(
                      addAutomaticKeepAlives: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        for (var movie in movies)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.sp),
                            child: Poster(
                              media: movie,
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                          )
                      ],
                    ));
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

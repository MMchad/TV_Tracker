import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/screens/movie_details/movie_details.dart';
import 'package:tv_tracker/shared/screens/show_details/show_details.dart';

class TitleSearchResultList extends StatelessWidget {
  final String query;
  const TitleSearchResultList({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchByQuery(
        query,
        Localizations.localeOf(context).languageCode,
      ),
      builder: (context, snapshot) {
        List results = (snapshot.data ?? []) as List;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            var result = results[index];
            return GestureDetector(
              onTap: () {
                if (results[index] is Show) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowDetailsScreen(show: results[index] as Show),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(movie: results[index] as Movie),
                    ),
                  );
                }
              },
              child: SizedBox(
                height: 120.h,
                child: Card(
                  color: ThemeData.dark().canvasColor,
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 120.h,
                          width: (120.h) * 0.6666666666666667,
                          child: results[index].posterPath != null
                              ? Image.network(
                                  getImageApiUrl(results[index].posterPath, "w200"),
                                  fit: BoxFit.contain,
                                )
                              : Icon(
                                  Icons.no_photography,
                                  size: 34.h,
                                ),
                        ),
                        SizedBox(
                          width: 15.sp,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.name ?? result.title,
                                style: GoogleFonts.roboto(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 3,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0.h),
                                child: Text(
                                  results[index].mediaType == "tv" ? "TV show" : "Movie",
                                  style: GoogleFonts.roboto(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 25.sp,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

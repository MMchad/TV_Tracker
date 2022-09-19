import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_movie_details.dart';
import 'package:tv_tracker/models/firestore_movie_model.dart';
import 'package:tv_tracker/screens/movies/components/movie_details_tile.dart';
import 'package:tv_tracker/shared/screens/move_list/movie_list.dart';
import 'package:tv_tracker/shared/widgets/outlined_icon_button.dart';
import '/providers/tmdb_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> with AutomaticKeepAliveClientMixin {
  void fetchMovieList() {}

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          toolbarHeight: 50.h,
          backgroundColor: const Color.fromARGB(255, 26, 25, 25),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.movieTitle,
            style: GoogleFonts.roboto(fontSize: 22.h, fontWeight: FontWeight.bold),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(FirebaseAuth.instance.currentUser!.uid)
                    .where("Type", isEqualTo: "Movie")
                    .where("Listed", isEqualTo: true)
                    .where("Watched", isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 40.h,
                        width: 40.h,
                        child: const CircularProgressIndicator(color: Colors.greenAccent),
                      ),
                    );
                  }
                  var data = snapshot.data as QuerySnapshot;
                  if (data.docs.isNotEmpty) {
                    return FutureBuilder(
                      future: Future.wait([
                        for (DocumentSnapshot doc in data.docs)
                          fetchAppendedMovieDetails(
                            doc.id,
                            Localizations.localeOf(context).languageCode,
                          )
                      ]),
                      builder: (context, future) {
                        if (future.connectionState == ConnectionState.done) {
                          List<AppendedMovieDetails> movies = future.data as List<AppendedMovieDetails>;
                          List<Widget> movieWidgets = [];
                          for (AppendedMovieDetails movie in movies) {
                            movieWidgets.add(MovieDetailsTile(movie: movie));
                            movieWidgets.add(
                              SizedBox(
                                height: 15.h,
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(children: movieWidgets),
                          );
                        }
                        return Center(
                          child: SizedBox(
                            height: 40.h,
                            width: 40.h,
                            child: const CircularProgressIndicator(color: Colors.greenAccent),
                          ),
                        );
                      },
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.emptyMovieList,
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      OutlinedIconButton(
                        title: AppLocalizations.of(context)!.discoverMovies,
                        icon: Icons.search,
                        fillColor: Colors.greenAccent,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        borderColor: Colors.transparent,
                        iconSize: 26,
                        fontSize: 18,
                        onPress: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MovieList())),
                      )
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

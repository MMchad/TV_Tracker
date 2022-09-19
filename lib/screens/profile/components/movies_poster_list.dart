import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/movie_details_model.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/screens/profile/components/movies.dart';
import 'package:tv_tracker/screens/profile/components/poster.dart';
import 'package:tv_tracker/shared/screens/move_list/movie_list.dart';
import 'package:tv_tracker/shared/widgets/placeholder_poster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileMoviesPosterList extends StatefulWidget {
  const ProfileMoviesPosterList({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileMoviesPosterList> createState() => _ProfileMoviesPosterListState();
}

class _ProfileMoviesPosterListState extends State<ProfileMoviesPosterList> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
    return Column(
      children: [
        SizedBox(
          height: 40.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.movies,
                style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              StreamBuilder(
                stream: ref.where("Type", isEqualTo: "Movie").limit(1).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  var data = snapshot.data as QuerySnapshot;
                  if (data.docs.isNotEmpty) {
                    return TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileMovies())),
                      child: Text(
                        AppLocalizations.of(context)!.viewAll,
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream: ref.where("Type", isEqualTo: "Movie").limit(10).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PlaceholderPoster();
            }
            var data = snapshot.data as QuerySnapshot;
            if (data.docs.isNotEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (DocumentSnapshot doc in data.docs)
                      FutureBuilder(
                        future: fetchMovieDetails(
                          doc.id,
                          Localizations.localeOf(context).languageCode,
                        ),
                        builder: (context, future) {
                          if (future.connectionState == ConnectionState.done && future.data != null) {
                            MovieDetails? movie = future.data as MovieDetails?;
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.sp),
                              child: ProfilePoster(
                                media: Movie.fromJson(movie!.toJson()),
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                            );
                          } else {
                            return const PlaceholderPoster();
                          }
                        },
                      ),
                  ],
                ),
              );
            }
            return Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: ((context) => const MovieList()))),
                  child: Container(
                    color: const Color.fromARGB(255, 26, 25, 25),
                    height: MediaQuery.of(context).size.height / 3,
                    width: (MediaQuery.of(context).size.height / 3) * 0.6666666666666667,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 150.h / 5,
                        ),
                        Text(
                          AppLocalizations.of(context)!.discoverMovies,
                          style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

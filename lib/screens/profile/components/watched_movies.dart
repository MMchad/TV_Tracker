import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_movie_details.dart';
import 'package:tv_tracker/models/movie_details_model.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/screens/profile/components/poster.dart';

class ProfileWatchedMovies extends StatelessWidget {
  final Stream filters;
  const ProfileWatchedMovies({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: filters,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        var data = snapshot.data as QuerySnapshot;
        if (data.docs.isNotEmpty) {
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2 / 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            crossAxisCount: 4,
            children: [
              for (DocumentSnapshot doc in data.docs)
                FutureBuilder(
                  future: fetchMovieDetails(
                    doc.id,
                    Localizations.localeOf(context).languageCode,
                  ),
                  builder: (context, future) {
                    if (future.connectionState == ConnectionState.done) {
                      MovieDetails movie = future.data as MovieDetails;
                      return ProfilePoster(
                        media: Movie.fromJson(movie.toJson()),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
            ],
          );
        }

        return Container();
      }),
    );
  }
}

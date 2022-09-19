import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tv_tracker/models/appended_movie_details.dart';
import 'package:tv_tracker/models/firestore_movie_model.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/shared/screens/movie_details/components/body.dart';
import 'package:tv_tracker/shared/screens/movie_details/components/bottom_bar.dart';
import 'package:tv_tracker/shared/widgets/media_details_app_bar.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;
  Future? movieDetails;
  bool? watched;
  bool? listed;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);

    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (tabController?.indexIsChanging ?? false) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    movieDetails = fetchAppendedMovieDetails(
      widget.movie.id.toString(),
      Localizations.localeOf(context).languageCode,
    );
    final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50.h,
        child: StreamBuilder(
          stream: ref.doc(widget.movie.id!.toString()).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            var data = snapshot.data as DocumentSnapshot;
            Map<String, dynamic>? map = data.data() as Map<String, dynamic>?;
            FirestoreMovie movie;
            map != null ? movie = FirestoreMovie.fromJson(map) : movie = FirestoreMovie(listed: false, type: "Movie", watched: false);
            return MovieDetailsBottombar(movie: movie, docRef: ref.doc(widget.movie.id!.toString()));
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 26, 25, 25),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          DetailsAppBar(
            media: widget.movie,
            mediaDetails: movieDetails!,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (BuildContext context, int index) {
                return FutureBuilder(
                  future: movieDetails,
                  builder: (context, future) {
                    if (future.connectionState == ConnectionState.done) {
                      return MovieDetailsBody(
                        movieDetails: future.data as AppendedMovieDetails,
                      );
                    } else {
                      return SizedBox(
                        height: (MediaQuery.of(context).size.height) - (MediaQuery.of(context).size.height / 2.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25.h,
                              width: 25.h,
                              child: const CircularProgressIndicator(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

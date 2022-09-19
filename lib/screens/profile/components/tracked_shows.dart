import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/models/appended_movie_details.dart';
import 'package:tv_tracker/models/movie_details_model.dart';
import 'package:tv_tracker/models/movie_model.dart';
import 'package:tv_tracker/models/show_details_model.dart';
import 'package:tv_tracker/models/show_model.dart';
import 'package:tv_tracker/providers/tmdb_api.dart';
import 'package:tv_tracker/screens/profile/components/poster.dart';

class ProfileTrackedShows extends StatelessWidget {
  final Stream filters;
  final bool hasStarted;
  const ProfileTrackedShows({super.key, required this.filters, this.hasStarted = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: filters,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData && snapshot.data == null) {
          return Container();
        }
        var data = snapshot.data as QuerySnapshot;
        var docs = [];
        if (hasStarted) {
          for (DocumentSnapshot doc in data.docs) {
            if ((doc.data() as Map<String, dynamic>)["Watched Length"] > 0) {
              docs.add(doc);
            }
          }
        } else {
          docs = data.docs;
        }
        if (docs.isNotEmpty) {
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2 / 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            crossAxisCount: 4,
            children: [
              for (DocumentSnapshot doc in docs)
                FutureBuilder(
                  future: fetchShowDetails(
                    doc.id,
                    Localizations.localeOf(context).languageCode,
                  ),
                  builder: (context, future) {
                    if (future.connectionState == ConnectionState.done) {
                      ShowDetails show = future.data as ShowDetails;
                      return ProfilePoster(
                        media: Show.fromJson(show.toJson()),
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

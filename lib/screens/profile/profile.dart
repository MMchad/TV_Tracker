import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/screens/profile/components/movies_poster_list.dart';
import 'package:tv_tracker/screens/profile/components/shows_poster_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  final String tmdbLogo =
      "https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg";
  final String tmdbAttribution = "This product uses the TMDB API but is not endorsed or certified by TMDB.";
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          actions: [
            PopupMenuButton(
                iconSize: 25.h,
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.white,
                            size: 25.h,
                          ),
                          Text(
                            " ${AppLocalizations.of(context)!.about}",
                            style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                            size: 25.h,
                          ),
                          Text(
                            " ${AppLocalizations.of(context)!.signOut}",
                            style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.ltr,
                            child: AlertDialog(
                              content: SizedBox(
                                height: 300.h,
                                width: 250.h,
                                child: Column(children: [
                                  SizedBox(height: 120.h, width: 120.h, child: SvgPicture.asset("assets/images/TMDB_Logo.svg")),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          tmdbAttribution,
                                          style: GoogleFonts.roboto(fontSize: 16.sp),
                                        ),
                                      )
                                    ],
                                  )
                                ]),
                              ),
                            ),
                          );
                        });
                  }
                  if (value == 1) {
                    FirebaseAuth.instance.signOut();
                  }
                }),
          ],
          pinned: true,
          floating: false,
          toolbarHeight: 50.h,
          backgroundColor: const Color.fromARGB(255, 26, 25, 25),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.profile,
            style: GoogleFonts.roboto(fontSize: 22.h, fontWeight: FontWeight.bold),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Column(
              children: [
                const ProfileMoviesPosterList(),
                SizedBox(
                  height: 15.h,
                ),
                const ProfileShowsPosterList(),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

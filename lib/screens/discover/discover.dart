import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_tracker/screens/discover/components/popular_movies.dart';
import 'package:tv_tracker/screens/discover/components/popular_shows.dart';
import 'package:tv_tracker/screens/discover/components/title_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_tracker/shared/widgets/details_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with AutomaticKeepAliveClientMixin<Discover> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      slivers: [
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          floating: false,
          toolbarHeight: 50.h,
          backgroundColor: const Color.fromARGB(255, 26, 25, 25),
          title: Text(AppLocalizations.of(context)!.discover, style: GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 6),
              onPressed: () {
                titleSearch(context);
              },
              icon: Icon(
                Icons.search,
                size: 28.h,
              ),
            ),
          ],
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(children: const [
            PopularShows(),
            PopularMovies(),
          ]),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
